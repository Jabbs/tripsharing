class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:create, :show]
  before_filter :correct_user, only: [:profile, :join, :edit, :update, :account, :photos, :email_settings, :privacy, :apps, :remove_images]
  before_filter :admin_user, only: [:index]
  # before_filter :check_complete_interests, only: [:profile]
  
  def show
    @user = User.friendly.find(params[:id])
    set_trips_counts(@user)
    @shared_likes = []; @mutual_friends = []
    # @graph = Koala::Facebook::API.new(@user.oauth_token, ENV["FACEBOOK_SECRET"]) if @user.oauth_token
    # if @graph && current_user.uid
    #   # @mutual_friends = @graph.get_connections("me", "mutualfriends/#{current_user.uid}")
    # end
    # @cu_graph = Koala::Facebook::API.new(current_user.oauth_token, ENV["FACEBOOK_SECRET"]) if current_user.oauth_token
    # if @cu_graph && @graph
    #   @user_likes = @graph.get_connections("me", "likes")
    #   @cu_likes = @cu_graph.get_connections("me", "likes")
    #   @shared_likes = @user_likes + @cu_likes
    #   @shared_likes = @shared_likes.select {|e| @shared_likes.count(e) > 1}.uniq
    # end
    @activities = @user.activities
    @join_request = JoinRequest.new
  rescue Koala::Facebook::AuthenticationError
  end
  
  def profile
    @user = User.friendly.find(params[:user_id])
  end
  
  def index
    @join_request_count = JoinRequest.count
    @message_count = Message.count
    @trip_count = Trip.where(state: "2").size
    @user_count = User.count
    @join_request_count_in_7_days = JoinRequest.where("created_at > ?", Date.today - 7.days).count
    @message_count_in_7_days = Message.where("created_at > ?", Date.today - 7.days).count
    @trip_count_in_7_days = Trip.where(state: "2").where("created_at > ?", Date.today - 7.days).size
    @user_count_in_7_days = User.where("created_at > ?", Date.today - 7.days).count
    @users = User.order("created_at DESC").paginate(page: params[:page], per_page: 50)
  end
  
  def join
  end
  
  def create
    raise ActionController::RoutingError.new('Not Found') if !params[:blankey].blank?
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      if @trip = Trip.find_by_id(cookies[:trip_id])
        connect_trip_to_user
        current_user.complete_welcome
        redirect_to trip_path(@trip)
      else
        redirect_to trips_path(@trip, welcome: 1)
      end
    else
      redirect_to root_path, alert: "There was an issue creating your account."
    end
  end
  
  def edit
  end
  def account
  end
  def photos
    @user.image_attachments.build
  end
  def email_settings
  end
  def privacy
  end
  def apps
  end
  
  def update
    @user = User.friendly.find(params[:id])
    @user.slug = nil
    fix_date_month_order
    if @user.update_attributes(user_params)
      update_interest_blob
      update_region_blob
      update_country_blob
      update_language_blob
      update_email_blob
      referrer = request.referer.split('/')
      logger.debug "$$$$$$$$$$$$$ #{referrer}"
      case referrer.last
      when "edit"
        redirect_to edit_user_path(@user), notice: "Your profile has been updated and saved."
      when "account"
        redirect_to user_account_path(@user), notice: "Your profile has been updated and saved."
      when "photos"
        redirect_to user_photos_path(@user), notice: "Your profile has been updated and saved."
      when "email_settings"
        redirect_to user_email_settings_path(@user), notice: "Your profile has been updated and saved."
      when "privacy"
        redirect_to user_privacy_path(@user), notice: "Your profile has been updated and saved."
      when "apps"
        redirect_to user_apps_path(@user), notice: "Your profile has been updated and saved."
      when "trips?welcome=1"
        redirect_to trips_path, notice: "Welcome to Tripsharing."
      else
        if referrer[3] == "trips" && referrer[4] && @trip = Trip.friendly.find(referrer[4].split("?").first)
          redirect_to @trip, notice: "Welcome to Tripsharing."
        else
          redirect_to current_user, notice: "Your profile has been updated and saved."
        end
      end
    else
      redirect_to edit_user_path(current_user), alert: "There was an issue updating your account."
    end
  end
  
  def remove_images
    @user = User.friendly.find(params[:user_id])
    x = 0
    if params[:remove_image]
      images = params[:remove_image]
      images.each do |image|
        if image[1] == 'on'
          ImageAttachment.find(image[0]).destroy
          x += 1
        end
      end
    end
    flash[:notice] = "Selected images have been removed." if x != 0
    redirect_to user_photos_path(@user)
  end
  
  private
    
    def user_params
      params.require(:user).permit(:admin, :auth_token, :email, :fb_hometown, :fb_image, :fb_location, 
                      :fb_url, :first_name, :gender, :last_name, :last_sign_in_at, :last_sign_in_ip, :newsletter, 
                      :oauth_expires_at, :oauth_token, :password_digest, :password_reset_sent_at, :password, :password_confirmation,
                      :password_reset_token, :phone, :sign_in_count, :slug, :subscribed, :uid, :verification_sent_at, 
                      :verification_token, :verified, :bio, :tag_line, :welcome_sent_at, :occupation,
                      :fb_locale, :fb_timezone, :fb_updated_time, :birthday, :hometown, :home_airport, :fb_occupation,
                      :status, :location, :education,
                      image_attachments_attributes: [:image, :description, :_destroy],)
    end
    
    def update_interest_blob
      # example preference_tags {"1"=>"1", "2"=>"2", "3"=>"2", "4"=>"3", "5"=>"3", "6"=>"3"}
      # example interest_blob "1-3,2-2,3-1,4-2,5-4,6-3"
      preference_tags = params[:preference_tags]
      unless preference_tags.nil?
        interest_blob = ""
        preference_tags.each do |p|
          interest_blob = interest_blob + p[0] + "-" + p[1] + ","
        end
        @user.interest_blob = interest_blob.chomp(",")
        @user.save
      end
    end
    
    def update_region_blob
      region_tags = params[:region_tags]
      unless region_tags.nil?
        region_blob = ""
        region_tags.each do |r|
          region_blob = region_blob + r[0] + ","
        end
        @user.region_blob = region_blob.chomp(",")
        @user.save
      end
    end
    
    def update_country_blob
      country_tags = params[:country_tags]
      unless country_tags.nil?
        country_blob = ""
        country_tags.each do |c|
          country_blob = country_blob + c[0] + ","
        end
        @user.country_blob = country_blob.chomp(",")
        @user.save
      end
    end
    
    def update_language_blob
      language_tags = params[:language_tags]
      unless language_tags.nil?
        language_blob = ""
        language_tags.each do |l|
          language_blob = language_blob + l[0] + ","
        end
        @user.language_blob = language_blob.chomp(",")
        @user.save
      end
    end
    
    def update_email_blob
      email_tags = params[:email_tags]
      unless email_tags.nil?
        email_blob = ""
        email_tags.each do |e|
          email_blob = email_blob + e[0] + ","
        end
        @user.email_blob = email_blob.chomp(",")
        @user.save
      end
    end
    
    def fix_date_month_order
      params[:user][:birthday] = Date.strptime(params[:user][:birthday],'%m/%d/%Y') if params[:user][:birthday].present?
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
