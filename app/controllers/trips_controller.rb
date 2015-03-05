class TripsController < ApplicationController
  before_filter :signed_in_user, except: [:show]
  before_filter :admin_user, only: [:lonelyplanet, :airports]
  before_filter :correct_user, only: [:edit, :update, :details]
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
    @first_stop = @trip.stops.where(order: 1).first
        
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
    create_tags if params["interest_tags"]
    fix_date_month_order
    if @trip.update_attributes(trip_params)
      if referrer == "details"
        current_user.nationality = params[:user][:nationality]
        current_user.occupation = params[:user][:occupation]
        current_user.save
        @trip.switch_to_state("2")
        redirect_to @trip
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
            
      params.require(:trip).permit(:group_age_max, :group_age_min, :description, :expires_at, :group_age_min, :group_age_max, :name, :active, :state,
                                   :duration_in_days, :price_dollars_low, :price_dollars_high, :departs_at, :currency, :group_dynamics,
                                   :region, :private, :seeking_type, :group_count, :duration, :time_flexibility, :departs_from, :departs_to,
                                   :group_departing_proximity, :group_relationship_status, :group_drinking, :group_personality, :group_nationality,
                                   :departing_category, :reason, :returns_at, :tag_list,
                                   image_attachments_attributes: [:image, :description],
                                   stops_attributes: [:to_iata, :from_iata, :to_name, :from_name, :transportation_type, :order],
                                   locations_attributes: [:address1, :address2, :city, :country, 
                                   :state, :zip, :latitude, :longitude, :display_on_map, :unparsed])
    end
    
    def fix_date_month_order
      params[:trip][:departs_at] = Date.strptime(params[:trip][:departs_at],'%m/%d/%Y') if params[:trip][:departs_at].present?
      params[:trip][:returns_at] = Date.strptime(params[:trip][:returns_at],'%m/%d/%Y') if params[:trip][:returns_at].present?
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
