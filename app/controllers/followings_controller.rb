class FollowingsController < ApplicationController
    before_filter :load_followable

    def create
      @following = @followable.followings.build(user_id: current_user.id)
      if @following.save
        # track_activity @following
        respond_to do |format|
          format.js
          # format.html { redirect_to @followable, notice: "You are now following this project!" }
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
        format.html { redirect_to @followable, alert: "You have unfollowed this project." }
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
