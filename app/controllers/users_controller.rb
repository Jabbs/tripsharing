class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:home]
  before_filter :correct_user, except: [:home]
  before_filter :check_complete_interests, only: [:profile]
  
  def home
    @fb_images_rand_5 = User.fb_image_random_5
    # @pete = User.find_by_email("petejabbour1@gmail.com")
    # @pete_rand5 = @pete.facebook_friends_photos_rand5
  end
  
  def profile
    
  end
  
  def browse
    
  end
  
  private
  
    def correct_user
      @user = User.find(params[:user_id])
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
