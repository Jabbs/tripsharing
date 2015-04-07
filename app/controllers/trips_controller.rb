class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:show, :details, :create, :update]
  before_filter :admin_user, only: [:lonelyplanet, :airports]
  before_filter :correct_user, only: [:edit, :remove_images]
  before_filter :correct_user_update_if_user, only: [:update]
  before_filter :redirect_inactive_trip, only: [:show]
  before_filter :redirect_incomplete_trip, only: [:show]
  
  def user_trips
    @user = User.friendly.find(params[:user_id])
    set_trips_counts(@user)
    if params[:incomplete]
      @trips = @user.trips.where(state: "1")
      redirect_to user_trips_path(@user) if !current_user?(@user)
    elsif params[:active]
      @trips = @user.trips.where(state: "2")
    elsif params[:in_progress]
      @trips = @user.trips.where(state: "6")
    elsif params[:completed]
      @trips = @user.trips.where(state: "5")
    else
      @trips = @user.trips
    end
    @join_request = JoinRequest.new
  end
  
  def lonelyplanet
    @lp_trips = Trip.get_lonelyplanet_trips
  end
  
  def airports

  end
  
  def details
    @session_user = User.new
    @user = User.new
    @remove_start_trip_button = true
    @trip = Trip.friendly.find(params[:trip_id])
  end

  def index
    if params[:search]
      @trips = Trip.where(state: "2").order("created_at DESC").search(params[:region], params[:departs_at], params[:returns_at], params[:tag]).paginate(page: params[:page], per_page: 18)
    else
      @trips = Trip.where(state: "2").order("created_at DESC").paginate(page: params[:page], per_page: 18)
    end
    # only show the user trips that fit their age
    @trips = @trips.where("group_age_min <= ?", current_user.age).where("group_age_max >= ?", current_user.age)
    @join_request = JoinRequest.new
  end
  
  def remove_images
    @trip = Trip.friendly.find(params[:trip_id])
    x = 0
    if params[:remove_image]
      images = params[:remove_image]
      images.each do |image|
        if image[1] == 'on'
          ImageAttachment.find(image[0]).destroy
          x += 1
        end
      end
    end
    flash[:notice] = "Selected images have been removed." if x != 0
    redirect_to @trip
  end
  
  def show
    @session_user = User.new
    @user = User.new
    @trip = Trip.friendly.find(params[:id])
    @trip.image_attachments.build
    @join_request = @trip.join_requests.new
    @stop = Stop.new(trip_id: @trip.id)
    @stops = @trip.stops.order(:created_at)
    @first_stop = @trip.stops.where(order: 1).first
        
    if request.path != trip_path(@trip) && request.path != user_trip_path(current_user, @trip)
      redirect_to @trip, status: :moved_permanently
    end
    # @trip.add_view_count unless current_user?(@trip.user) || admin_user?
    
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "The trip you attempted to view is no longer available."
  end
  
  def edit
    @trip = Trip.friendly.find(params[:id])
  end
  
  def update
    @trip = Trip.friendly.find(params[:id])
    @trip.slug = nil
    referrer = request.referer.split('/').last
    create_tags if params["interest_tags"]
    fix_date_month_order
    if @trip.update_attributes(trip_params)
      update_user_interest_blob
      if referrer == "details"
        if current_user
          @trip.switch_to_state("2")
          track_activity @trip, "activated"
          Notification.add_to(@trip.user, "D")
          UserMailer.delay.trip_d_email(@trip.user, @trip)
        else
          cookies[:trip_id] = @trip.id
          @trip.switch_to_state("7")
        end
        redirect_to @trip
      else
        redirect_to @trip, notice: 'Trip successfully updated.'
      end
    else
      redirect_to @trip, alert: 'There was an issue updating your trip.'
    end
  end
  
  def create
    raise ActionController::RoutingError.new('Not Found') if !params[:blankey].blank?
    # @my_trips = current_user.trips
    @trip = Trip.new(trip_params)
    @trip.user = current_user if current_user
    @trip.add_predetermined_ages
    if @trip.save
      redirect_to trip_details_path(@trip)
    else
      redirect_to root_path, alert: "You must create a name for your trip."
    end
  end
  
  def destroy
    @trip = Trip.friendly.find(params[:id])
    @trip.destroy
    
    redirect_to root_path, alert: "The Trip has been removed."
  end
  
  def deactivate
    @trip = Trip.friendly.find(params[:trip_id])
    @trip.deactivate

    redirect_to @trip, notice: "This Trip has been deactivated."
  end
  
  private
    
    def trip_params
      
      params.require(:trip).permit(:group_age_max, :group_age_min, :description, :expires_at, :group_age_min, :group_age_max, :name, :active, :state,
                                   :duration_in_days, :departs_at, :group_dynamics,
                                   :region, :private, :seeking_type, :group_count, :duration, :time_flexibility,
                                   :group_nationality, :stop_location, :user_occupation, :user_nationality, :user_interest_blob,
                                   :departing_category, :reason, :returns_at, :tag_list, :default_image,
                                   image_attachments_attributes: [:image, :description, :_destroy],
                                   stops_attributes: [:to_iata, :from_iata, :to_name, :from_name, :transportation_type, :order, :to_date, :from_date],
                                   locations_attributes: [:address1, :address2, :city, :country, 
                                   :state, :zip, :latitude, :longitude, :display_on_map, :unparsed])
    end
    
    def fix_date_month_order
      if params[:trip].present?
        params[:trip][:departs_at] = Date.strptime(params[:trip][:departs_at],'%m/%d/%Y') if params[:trip][:departs_at].present?
        params[:trip][:returns_at] = Date.strptime(params[:trip][:returns_at],'%m/%d/%Y') if params[:trip][:returns_at].present?
      end
    end
    
    def update_user_interest_blob
      preference_tags = params[:preference_tags]
      unless preference_tags.nil?
        user_interest_blob = ""
        preference_tags.each do |p|
          user_interest_blob = user_interest_blob + p[0] + "-" + p[1] + ","
        end
        @trip.user_interest_blob = user_interest_blob.chomp(",")
        @trip.save
      end
    end
    
    def create_tags
      tag_blob = params["interest_tags"]
      tag_blob.each do |k,v|
        if v == "1"
          name = Trip::INTERESTS[k].parameterize
          if Tag.find_by_name(name)
            t = Tag.find_by_name(name)
          else
            t = Tag.create!(name: name)
          end
          @trip.taggings.build(tag_id: t.id)
        end
      end
    end
    
    def admin_user
      redirect_to root_path unless admin_user?
    end
    
    def correct_user
      params[:trip_id]? id = params[:trip_id] : id = params[:id]
      @trip = Trip.friendly.find(id)
      redirect_to root_path unless current_user == @trip.user
    end
    
    def correct_user_update_if_user
      if current_user
        params[:trip_id]? id = params[:trip_id] : id = params[:id]
        @trip = Trip.friendly.find(id)
        redirect_to root_path unless current_user == @trip.user
      end
    end
    
    def redirect_inactive_trip
      @trip = Trip.friendly.find(params[:id])
      redirect_to root_path, alert: "The trip you tried to visit is not active." if @trip.inactive? && !admin_user? && !current_user?(@trip.user)
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "The trip you attempted to view is no longer available."
    end
    
    def redirect_incomplete_trip
      @trip = Trip.friendly.find(params[:id])
      redirect_to trip_details_path(@trip) if @trip.incomplete?
    end
end
