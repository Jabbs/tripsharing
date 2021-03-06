class JoinRequestsController < ApplicationController
  before_filter :get_trip
  before_filter :signed_in_user
  before_filter :correct_user, only: [:accept, :decline]
  before_filter :verified_user
  
  def create
    @join_request = @trip.join_requests.build(join_request_params)
    @join_request.user = current_user
    if @join_request.save
      @join_request.trip.user.add_friend(current_user)
      UserMailer.delay.join_request_new_email(@join_request.trip.user, @join_request.trip.user.verification_token, @join_request)
      redirect_to @trip, notice: "Your join request has been sent."
    else
      redirect_to @trip, alert: "There was an issue submitting your request to join this trip."
    end
  end
  
  def accept
    @join_request = JoinRequest.find(params[:join_request_id])
    @join_request.change_to_accepted
    @join_request.user.add_friend(current_user)
    Notification.add_to(@join_request.user, "H", @join_request)
    UserMailer.delay.join_request_accepted_email(@join_request.user, @join_request.user.verification_token, @join_request)
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
    
    def verified_user
      redirect_to current_user, alert: 'You must have a verified email account to send join requests' unless current_user.verified
    end
    
end
