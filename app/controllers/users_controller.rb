class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:create]
  before_filter :correct_user, except: [:index, :create]
  before_filter :admin_user, only: [:index]
  before_filter :check_complete_interests, only: [:profile]
  
  def profile
    @user = User.find(params[:user_id])
  end
  
  def index
    @users = User.order("created_at DESC")
  end
  
  def join
  end
  
  def create
    raise ActionController::RoutingError.new('Not Found') if !params[:blankey].blank?
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      create_survey_from_user
      redirect_to user_interests_path(@user)
    else
      render 'static_pages/home'
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_join_path(current_user)
    else
      redirect_to user_profile_path(current_user), alert: "We encountered an error."
    end
  end
  
  def browse
    
  end
  
  private
    
    def user_params
      params.require(:user).permit(:admin, :auth_token, :birth_year, :email, :fb_hometown, :fb_image, :fb_location, 
                      :fb_url, :first_name, :gender, :last_name, :last_sign_in_at, :last_sign_in_ip, :newsletter, 
                      :oauth_expires_at, :oauth_token, :password_digest, :password_reset_sent_at, :password,
                      :password_reset_token, :phone, :sign_in_count, :slug, :subscribed, :uid, :verification_sent_at, 
                      :verification_token, :verified, :bio, :tag_line, :welcome_sent_at, :occupation,
                      :fb_locale, :fb_timezone, :fb_updated_time, :birthday, :hometown)
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
    def correct_user
      params[:user_id]? id = params[:user_id] : id = params[:id]
      @user = User.find(id)
      redirect_to root_path unless current_user?(@user) || current_user.admin?
    end
    
    def check_complete_interests
      count = 0
      count += 1 if current_user.interests.where(category: "Destination").where(has_it: true).any?
      count += 1 if current_user.interests.where(category: "Duration").where(has_it: true).any?
      count += 1 if current_user.interests.where(category: "Time of Year").where(has_it: true).any?
      count += 1 if current_user.interests.where(category: "Group Dynamics").where(has_it: true).any?
      count += 1 if current_user.interests.where(category: "General").where(has_it: true).any?
      redirect_to user_interests_path(current_user), alert: "WHOOPS. Please select at least one interest per category to continue..." unless count == 5
    end
end
