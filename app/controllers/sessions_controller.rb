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
      if @trip = Trip.find_by_id(cookies[:trip_id])
        connect_trip_to_user
        if current_user.welcome_complete?
          redirect_to trip_path
        else
          current_user.complete_welcome
          redirect_to trip_path(@trip, welcome: 1)
        end
      else
        if current_user.welcome_complete?
          redirect_to trips_path
        else
          current_user.complete_welcome
          redirect_to trips_path(@trip, welcome: 1)
        end
      end
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
