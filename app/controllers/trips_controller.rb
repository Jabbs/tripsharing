class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:index, :show]
  before_filter :admin_user, only: [:lonelyplanet]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :redirect_inactive_trip, only: [:show]
  
  def lonelyplanet
    @lp_trips = Trip.get_lonelyplanet_trips
  end
  
  def index
    @trips = Trip.order("created_at ASC").paginate(page: params[:page], per_page: 12)
    @my_trips = current_user.trips
  end
  
  def new
    @trip = Trip.new
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
    if @trip.update_attributes(trip_params)
      @trip.save!
      redirect_to [current_user, @trip], notice: 'Trip successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    if @trip.save
      redirect_to trips_path, notice: "Your trip has been created!"
    else
      render 'new'
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
                                   :region, image_attachments_attributes: [:image, :description],
                                   locations_attributes: [:address1, :address2, :city, :country, 
                                   :state, :zip, :latitude, :longitude, :display_on_map, :unparsed])
    end
  
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
    def correct_user
      @trip = Trip.friendly.find(params[:id])
      redirect_to root_path unless current_user == @trip.user
    end
    
    def redirect_inactive_trip
      @trip = Trip.friendly.find(params[:id])
      redirect_to root_path, alert: "The trip you tried to visit is not active." if @trip.inactive? && !admin_user? && !current_user?(@trip.user)
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "The trip you attempted to view is no longer available."
    end
end
