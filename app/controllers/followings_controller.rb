class FollowingsController < ApplicationController
  before_filter :signed_in_user
  before_filter :load_followable

  def create
    @following = @followable.followings.build(user_id: current_user.id)
    Notification.add_to(@followable.user, "O", current_user)
    if @following.save
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path, alert: "There was an issue following this."
    end
  end

  def destroy
    @following = Following.find(params[:id])

    @following.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def load_followable
      resource, id = request.path.split('/')[1, 2]
      logger.debug "RESOURCE: #{resource}, ID: #{id}"
      resource = "users" if resource == "members"
      @followable = resource.singularize.classify.constantize.friendly.find(id)
      logger.debug "@followable: #{@followable}"
    end
end
