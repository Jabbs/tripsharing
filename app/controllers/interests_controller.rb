class InterestsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  
  def index
    @interests = current_user.interests
  end
  
  def update
    @interest = current_user.interests.find(params[:id])
    @interest.has_it? ? @interest.has_it = false : @interest.has_it = true
    if @interest.save
      respond_to do |format|
        format.js
      end
    end
  end
  
  def create
    @interest = current_user.interests.build(identifier: params[:identifier])
    if @interest.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path alert: "The application encountered an error."
    end
  end
  
  def destroy
    @interest = current_user.interests.find(params[:id])
    @interest.destroy
    respond_to do |format|
      format.js
    end
    
  end
  
  private
  
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_path unless current_user?(@user) || current_user.admin?
    end
end
