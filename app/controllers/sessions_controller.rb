class SessionsController < ApplicationController
  def new
    @session_user = User.new
    @user = User.new
  end

  def create
    if params[:provider] == "facebook"
      @session_user = User.from_omniauth(env["omniauth.auth"])
      logger.debug "request.referer: #{request.referer}"
      sign_in @session_user
      redirect_to trips_path
    else
      @session_user = User.find_by_email(params[:email].to_s.downcase)
      if @session_user && @session_user.authenticate(params[:password].to_s)
        sign_in @session_user
        redirect_to trips_path
      else
        @user = User.new
        @session_user = User.new
        @session_user.errors.add(:email, "or password invalid")
        redirect_to root_path, alert: "Invalid email or password."
      end
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path
  end

end
