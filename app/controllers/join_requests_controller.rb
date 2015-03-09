class JoinRequestsController < ApplicationController
  before_filter :get_trip
  before_filter :signed_in_user
  
  def create
    @join_request = @trip.join_requests.build(join_request_params)
    @join_request.user = current_user
    if @join_request.save
      redirect_to @trip, notice: "Your request to join this trip has been sent to the organizer."
    else
      redirect_to @trip, alert: "There was an issue submitting your request to join this trip."
    end
  end
  
  private
    
    def get_trip
      @trip = Trip.friendly.find(params[:trip_id])
    end
    
    def join_request_params
      params.require(:join_request).permit(:content)
    end
    
end
