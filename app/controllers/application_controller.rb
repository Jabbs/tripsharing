class ApplicationController < ActionController::Base
  if Rails.env.production? && ENV['STAGING'] == "true"
    http_basic_authenticate_with :name => "pj", :password => "pj"
  end
  before_filter :ensure_domain
  before_filter :instantiate_new_trip
  before_filter :record_user_activity
  before_filter :instantiate_welcome_trips
  before_filter :get_notifications
  before_filter :load_new_message
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
  
  def load_new_message
    @new_message = current_user.sent_messages.new if current_user
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
    if params[:welcome] == "1"
      @welcome_user = current_user
      @welcome_user.image_attachments.build
    end
  end
  
  def connect_trip_to_user
    @trip.user = current_user
    @trip.switch_to_state("2")
    @trip.save!
    track_activity @trip, "activated"
    UserMailer.delay.trip_new_email(@trip.user, @trip)
    current_user.occupation = @trip.user_occupation if current_user.occupation.blank?
    current_user.nationality = @trip.user_nationality if current_user.nationality.blank?
    current_user.interest_blob = @trip.user_interest_blob if current_user.interest_blob.blank?
    current_user.save!
    cookies.delete(:trip_id)
  end
  
  private
  
    def get_notifications
      if current_user
        @join_requests_received = current_user.join_requests_received.where(state: "0").with_badges_unviewed
        @join_requests_received_count = current_user.join_requests_received.where(state: "0").with_badges_unviewed.size
        @received_messages = current_user.received_messages.where(viewed: false).with_badges_unviewed
        @received_messages_count = current_user.received_messages.where(viewed: false).with_badges_unviewed.size
        @new_join_requests_and_messages = @join_requests_received + @received_messages
        @new_messages_count = @join_requests_received_count + @received_messages_count
        @new_notifications = current_user.notifications.with_badges_unviewed
        @new_notifications_count = current_user.notifications.with_badges_unviewed.size
      else
        @join_requests_received_count = 0
        @received_messages_count = 0
        @new_messages_count = 0
        @new_notifications_count = 0
      end
    end

    def record_user_activity
      if current_user
        current_user.touch :last_sign_in_at
      end
    end
  
end
