class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  def show
  end
  
  def create
    @user = User.friendly.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.js
    end
  end

end
