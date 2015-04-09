class NotificationsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  before_filter :verified_user
  
  def index
    @notifications = current_user.notifications.order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end
  
  private
    
    def correct_user
      @user = User.friendly.find(params[:user_id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
    
    def verified_user
      redirect_to current_user, alert: 'You must have a verified email account to access notifications' unless current_user.verified
    end
end
