class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :admin_user, only: [:lonelyplanet]
  before_filter :correct_user, only: [:edit, :update, :details, :travel_companions]
  before_filter :redirect_inactive_trip, only: [:show]
  before_filter :redirect_incomplete_trip, only: [:show]
  
  def lonelyplanet
    @lp_trips = Trip.get_lonelyplanet_trips
  end
  
  def airports

  end
  
  def details
    @remove_start_trip_button = true
    @trip = Trip.friendly.find(params[:trip_id])
  end

  def index
    @trips = Trip.order("created_at ASC").paginate(page: params[:page], per_page: 12)
    @my_trips = current_user.trips
  end
  
  def show
    @my_trips = current_user.trips
    @trip = Trip.friendly.find(params[:id])
    
    if request.path != trip_path(@trip) && request.path != user_trip_path(current_user, @trip)
      redirect_to @trip, status: :moved_permanently
    end
    @trip.add_view_count unless current_user?(@trip.user) || admin_user?
    
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
    if @trip.update_attributes(trip_params)
      @trip.save!
      if referrer == "details"
        redirect_to trip_details_path(@trip)
      else
        redirect_to @trip, notice: 'Trip successfully updated.'
      end
    else
      render action: "edit"
    end
  end
  
  def create
    @my_trips = current_user.trips
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    @trip.add_predetermined_ages
    if @trip.save
      redirect_to trip_details_path(@trip)
    else
      render 'index'
    end
  end
  
  def destroy
    @trip = Trip.friendly.find(params[:id])
    @trip.destroy
    
    redirect_to root_path, alert: "The Trip has been removed."
  end
  
  private
    
    def trip_params
      params.require(:trip).permit(:age_max, :age_min, :description, :expires_at, :group_min, :group_max, :name, :active, :state,
                                   :duration_in_days, :price_dollars_low, :price_dollars_high, :departs_at, :currency, :group_dynamics,
                                   :region, :private, :seeking_type, :seeking_count, :duration, :time_flexibility, 
                                   image_attachments_attributes: [:image, :description],
                                   locations_attributes: [:address1, :address2, :city, :country, 
                                   :state, :zip, :latitude, :longitude, :display_on_map, :unparsed])
    end
  
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
    def correct_user
      params[:trip_id]? id = params[:trip_id] : id = params[:id]
      @trip = Trip.friendly.find(id)
      redirect_to root_path unless current_user == @trip.user
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
