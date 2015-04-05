require 'sidekiq'
require 'sidekiq/web'
require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

# https://github.com/mperham/sidekiq/issues/1720

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["pj", "pj"]
end

ENV["REDISTOGO_URL"] ||= "redis://localhost:6379"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDISTOGO_URL"], namespace: 'sidekiq' }
end

unless Rails.env.production? || Rails.env.staging?
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV["REDISTOGO_URL"], namespace: 'sidekiq'  }
  end
end

heroku = nil
if ENV['HEROKU_APP']
  heroku = Autoscaler::HerokuScaler.new
end

Sidekiq.configure_client do |config|
  if heroku
    config.client_middleware do |chain|
      chain.add Autoscaler::Sidekiq::Client, 'default' => heroku
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    if heroku
      p "[Sidekiq] Running on Heroku, autoscaler is used"
      chain.add(Autoscaler::Sidekiq::Server, heroku, 60) # 60 seconds timeout
    else
      p "[Sidekiq] Running locally, so autoscaler isn't used"
    end
  end
end