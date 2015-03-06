class StopsController < ApplicationController
  before_filter :get_trip
  before_filter :get_stops
  before_filter :signed_in_user
  before_filter :correct_user
  respond_to :html, :js
  
  def create
    @stop = @trip.stops.build(stop_params)
    @stop.user = current_user
    if @stop.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path alert: "The application encountered an error."
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
    
    def get_trip
      @trip = Trip.friendly.find(params[:trip_id])
    end
    
    def get_stops
      @stops = @trip.stops
    end
    
    def stop_params
      params.require(:stop).permit(:to_iata, :from_iata, :to_name, :from_name, :transportation_type, :order, :to_date, :from_date)
    end
    
    def correct_user
      redirect_to root_path unless current_user?(@trip.user) || admin_user?
    end
end
