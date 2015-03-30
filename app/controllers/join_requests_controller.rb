class JoinRequestsController < ApplicationController
  before_filter :get_trip
  before_filter :signed_in_user
  before_filter :correct_user, only: [:accept, :decline]
  
  def create
    @join_request = @trip.join_requests.build(join_request_params)
    @join_request.user = current_user
    if @join_request.save
      redirect_to @trip, notice: "Your join request has been sent."
    else
      redirect_to @trip, alert: "There was an issue submitting your request to join this trip."
    end
  end
  
  def accept
    @join_request = JoinRequest.find(params[:join_request_id])
    @join_request.change_to_accepted
    redirect_to user_join_requests_path(current_user), notice: "This travel companion has been added to your trip."
  end
  
  def decline
    @join_request = JoinRequest.find(params[:join_request_id])
    @join_request.change_to_declined
    redirect_to user_join_requests_path(current_user)
  end
  
  private
    
    def correct_user
      redirect_to root_path unless current_user?(@trip.user)
    end
    
    def get_trip
      @trip = Trip.friendly.find(params[:trip_id])
    end
    
    def join_request_params
      params.require(:join_request).permit(:content)
    end
    
end
