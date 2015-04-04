class ApplicationController < ActionController::Base
  if Rails.env.production? && ENV['STAGING'] == "true"
    http_basic_authenticate_with :name => "pj", :password => "pj"
  end
  before_filter :ensure_domain
  before_filter :instantiate_new_trip
  before_filter :record_user_activity
  before_filter :instantiate_welcome_trips
  # before_filter :set_airports
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  
  APP_DOMAIN = 'www.trip-sharing.com'
  
  def track_activity(trackable, action = params[:action])
    current_user.activities.create!(trackable: trackable, action: action) if current_user
  end

  def ensure_domain
    if (Rails.env.production? && request.env['HTTP_HOST'] != APP_DOMAIN) && ENV['STAGING'].nil?
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end
  
  def set_airports
    @airports ||= view_context.render 'trips/airports.json'
  end
  
  def instantiate_new_trip
    if current_user
      @new_trip = Trip.new(user_id: current_user.id)
    else
      @new_trip = Trip.new
    end
  end
  
  def instantiate_welcome_trips
    @welcome_trips = Trip.where(state: "2").last(3)
  end
  
  def connect_trip_to_user
    @trip.user = current_user
    @trip.save!
    current_user.occupation = @trip.user_occupation
    current_user.nationality = @trip.user_nationality
    current_user.interest_blob = @trip.user_interest_blob
    current_user.save!
    cookies.delete(:trip_id)
  end
  
  private

    def record_user_activity
      if current_user
        current_user.touch :last_sign_in_at
      end
    end
  
end
