class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:create]
  before_filter :correct_user, only: [:profile, :join, :edit, :update]
  before_filter :admin_user, only: [:index]
  # before_filter :check_complete_interests, only: [:profile]
  
  def show
    @user = User.friendly.find(params[:id])
    @graph = Koala::Facebook::API.new(@user.oauth_token, ENV["FACEBOOK_SECRET"])
    @mutual_friends = @graph.get_connections("me", "mutualfriends/#{current_user.uid}")
    @cu_graph = Koala::Facebook::API.new(current_user.oauth_token, ENV["FACEBOOK_SECRET"])
    @user_likes = @graph.get_connections("me", "likes")
    @cu_likes = @cu_graph.get_connections("me", "likes")
    @shared_likes = @user_likes + @cu_likes
    @shared_likes = @shared_likes.select {|e| @shared_likes.count(e) > 1}.uniq
  end
  
  def profile
    @user = User.friendly.find(params[:user_id])
  end
  
  def index
    @users = User.order("created_at DESC")
  end
  
  def join
  end
  
  def create
    raise ActionController::RoutingError.new('Not Found') if !params[:blankey].blank?
    fix_date_month_order
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      create_survey_from_user
      unless current_user.trips.any?
        Trip.create_from_survey(current_user, current_user.survey) if current_user.survey
      end
      if current_user.trips.any? && current_user.send_to_first_trip == true
        current_user.send_to_first_trip == false
        current_user.save
        redirect_to current_user.trips.first
      else
        redirect_to trips_path
      end
    else
      logger.debug("ERRORS: #{@user.errors.full_messages}")
      redirect_to root_path, alert: "There was an issue creating your account."
    end
  end
  
  def edit
    
  end
  
  def update
    @user = User.friendly.find(params[:id])
    @user.slug = nil
    if @user.update_attributes(user_params)
      redirect_to current_user, notice: "Your profile has been updated."
    else
      redirect_to edit_user_path(current_user), alert: "We encountered an error."
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:admin, :auth_token, :birth_year, :email, :fb_hometown, :fb_image, :fb_location, 
                      :fb_url, :first_name, :gender, :last_name, :last_sign_in_at, :last_sign_in_ip, :newsletter, 
                      :oauth_expires_at, :oauth_token, :password_digest, :password_reset_sent_at, :password,
                      :password_reset_token, :phone, :sign_in_count, :slug, :subscribed, :uid, :verification_sent_at, 
                      :verification_token, :verified, :bio, :tag_line, :welcome_sent_at, :occupation,
                      :fb_locale, :fb_timezone, :fb_updated_time, :birthday, :hometown, :home_airport, :fb_occupation)
    end
    
    def fix_date_month_order
      logger.debug("111111: #{params[:user][:birthday]}")
      params[:user][:birthday] = Date.strptime(params[:user][:birthday],'%m/%d/%Y') if params[:user][:birthday].present?
      logger.debug("222222: #{params[:user][:birthday]}")
    end
    
    def admin_user
      redirect_to root_path unless admin_user?
    end
    
    def correct_user
      params[:user_id]? id = params[:user_id] : id = params[:id]
      @user = User.friendly.find(id)
      redirect_to root_path unless current_user?(@user) || admin_user?
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
