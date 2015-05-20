class UserMailer < ActionMailer::Base
  default from: "#{ENV['APP_ROOT_NAME']} <no-reply@tripsharing.com>"
  default content_type: "text/html"
  
  # sent to users 1 to 102 (unless user.cohort_blob.include?("A")) 4/27/15 12:35pm
  def announcements_update_1_email(user, user_verification_token)
    @email_type = "B"; @user_verification_token = user_verification_token
    if user.subscribed_to?(@email_type)
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Update: Tripsharing Version 1.0")
    end
  end
  
  def join_request_accepted_email(user, user_verification_token, join_request)
    @email_type = "H"; @user_verification_token = user_verification_token
    if user.subscribed_to?(@email_type)
      @join_request = join_request
      unless @join_request.accepted_email_sent_at.present?
        mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "You have received a request to join your trip")
        @join_request.accepted_email_sent_at = DateTime.now
        @join_request.save!
      end
    end
  end
  
  def join_request_new_email(user, user_verification_token, join_request)
    @email_type = "G"; @user_verification_token = user_verification_token
    if user.subscribed_to?(@email_type)
      @join_request = join_request
      unless @join_request.new_email_sent_at.present?
        mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "You have received a request to join your trip")
        @join_request.new_email_sent_at = DateTime.now
        @join_request.save!
      end
    end
  end
  
  def message_new_email(user, user_verification_token, message)
    @email_type = "P"; @user_verification_token = user_verification_token
    logger.debug "VERIFICATION TOKEN: #{@user_verification_token}"
    if user.subscribed_to?(@email_type)
      @message = message
      unless @message.email_sent_at.present?
        mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "You have received a message")
        @message.email_sent_at = DateTime.now
        @message.save!
      end
    end
  end
  
  def trip_new_email(user, user_verification_token, trip)
    @email_type = "F"; @user_verification_token = user_verification_token
    if user.subscribed_to?(@email_type)
      @trip = trip
      unless @trip.new_email_sent_at.present?
        mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your new Trip on Tripsharing")
        @trip.new_email_sent_at = DateTime.now
        @trip.save!
      end
    end
  end
  
  def trips_weekly_newsletter(user, user_verification_token, trip)
    @email_type = "E"; @user_verification_token = user_verification_token
    if user.subscribed_to?(@email_type)
      @trip = trip
      @user = user
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Weekly digest - Trips you may be interested in joining...")
    end
  end
  
  def user_password_reset_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Reset your password")
    @user.password_reset_sent_at = DateTime.now
    @user.save
  end
  
  def user_verification_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Verify your email address")
    @user.verification_sent_at = DateTime.now
    @user.save
  end
  
  def user_welcome_email(user)
    # Currently just used as a template for other emails
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Welcome to Tripsharing!")
    @user.welcome_sent_at = DateTime.now
    @user.save
  end
  
end
