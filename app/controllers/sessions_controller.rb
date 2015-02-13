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
      create_survey_from_user
      unless current_user.trips.any?
        Trip.create_from_survey(current_user, current_user.survey) if current_user.survey
      end
      if current_user.trips.any? && current_user.send_to_first_trip == true
        current_user.send_to_first_trip == false
        current_user.save
        redirect_to current_user.trips.first
      else
        redirect_back_or user_trips_path(current_user)
      end
    else
      @session_user = User.find_by_email(params[:email].to_s.downcase)
      if @session_user && @session_user.authenticate(params[:password].to_s)
        sign_in @session_user
        redirect_back_or user_trips_path(current_user)
      else
        @user = User.new
        @session_user = User.new
        @session_user.errors.add(:email, "or password invalid")
        redirect_to home_path, alert: "Invalid email or password."
      end
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path
  end

end
