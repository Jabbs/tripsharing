class UsersController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, except: [:index]
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
