class ApplicationController < ActionController::Base
  if Rails.env.production? && ENV['STAGING'] == "true"
    http_basic_authenticate_with :name => "pj", :password => "pj"
  end
  before_filter :ensure_domain
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  
  APP_DOMAIN = 'www.trip-sharing.com'

  def ensure_domain
    if (Rails.env.production? && request.env['HTTP_HOST'] != APP_DOMAIN) && ENV['STAGING'].nil?
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end
  
  def create_survey_from_user
    if current_user && cookies[:survey_id]
      @survey = Survey.find(cookies[:survey_id])
      if @survey
        @survey.user = current_user
        @survey.save
      end
    end
  end
  
end
