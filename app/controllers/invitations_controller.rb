class InvitationsController < ApplicationController
  before_filter :get_trip
  before_filter :get_invitations
  before_filter :signed_in_user
  before_filter :correct_user
  
  def create
    @invitation = @trip.invitations.build(invitation_params)
    @invitation.user = current_user
    @invitation.save
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @invitation = @trip.invitations.find(params[:id])
    @invitation.destroy
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def get_trip
      @trip = Trip.friendly.find(params[:trip_id])
    end
    
    def get_invitations
      @invitations = @trip.invitations.order(:created_at)
      @invitation = Invitation.new(trip_id: @trip.id)
    end
    
    def invitation_params
      params.require(:invitation).permit(:name, :email)
    end
    
    def correct_user
      redirect_to root_path unless current_user?(@trip.user) || admin_user?
    end
end
