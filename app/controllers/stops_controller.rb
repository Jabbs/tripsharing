class StopsController < ApplicationController
  before_filter :get_trip
  before_filter :get_stops
  before_filter :signed_in_user
  before_filter :correct_user
  respond_to :html, :js
  
  def create
    fix_date_month_order
    @stop = @trip.stops.build(stop_params)
    @stop.user = current_user
    @stop.to_name = ""
    if fields_arent_blank && @stop.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to @trip, alert: "You must fill out at least one field."
    end
  end
  
  def destroy
    @stop = @trip.stops.find(params[:id])
    @stop.destroy
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def fields_arent_blank
      params[:stop][:to_name].blank? && params[:stop][:to_name_dest].blank? ? false : true
    end
  
    def fix_date_month_order
      params[:stop][:to_date] = Date.strptime(params[:stop][:to_date],'%m/%d/%Y') if params[:stop][:to_date].present?
    end
    
    def get_trip
      @trip = Trip.friendly.find(params[:trip_id])
    end
    
    def get_stops
      @stops = @trip.stops.order(:created_at)
      @stop = Stop.new(trip_id: @trip.id)
    end
    
    def stop_params
      params.require(:stop).permit(:to_iata, :from_iata, :to_name, :from_name, :transportation_type, :order, :to_date, :from_date, :to_name_dest)
    end
    
    def correct_user
      redirect_to root_path unless current_user?(@trip.user) || admin_user?
    end
end
