CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],                        # required
    :aws_secret_access_key  => ENV['AWS_SECRET_KEY'],                        # required
    # :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
    # :host                   => 's3.example.com',             # optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = ENV['AWS_S3_BUCKET']                     # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  config.cache_dir      = "#{Rails.root}/tmp/upload" 
  
  if Rails.env.production? && ENV['STAGING'].nil?
    config.asset_host       = 'http://www.trip-sharing.com/'
  elsif Rails.env.production? && ENV['STAGING'] == 'true'
    config.asset_host       = 'http://tripsharing-staging.herokuapp.com/f/'
  else
    config.asset_host       = 'http://localhost:3000'
  end
  
end