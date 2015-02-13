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
      if @survey = Survey.find_by_id(cookies[:survey_id])
        if @survey && !current_user.survey.present?
          @survey.user = current_user
          current_user.send_to_first_trip = true
          current_user.save
          @survey.save
        end
      end
    end
  end
  
end
