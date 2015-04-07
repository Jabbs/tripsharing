class UserMailer < ActionMailer::Base
  default from: "#{ENV['APP_ROOT_NAME']} <no-reply@tripsharing.com>"
  default content_type: "text/html"
  
  def join_request_accepted_email(user, join_request)
    @join_request = join_request
    unless @join_request.accepted_email_sent_at.present?
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your have received a request to join your trip")
      @join_request.accepted_email_sent_at = DateTime.now
      @join_request.save!
    end
  end
  
  def join_request_new_email(user, join_request)
    @join_request = join_request
    unless @join_request.new_email_sent_at.present?
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your have received a request to join your trip")
      @join_request.new_email_sent_at = DateTime.now
      @join_request.save!
    end
  end
  
  def message_new_email(user, message)
    @message = message
    unless @message.email_sent_at.present?
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your have received a message")
      @message.email_sent_at = DateTime.now
      @message.save!
    end
  end
  
  def trip_new_email(user, trip)
    @trip = trip
    unless @trip.new_email_sent_at.present?
      mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your new Trip on Tripsharing")
      @trip.new_email_sent_at = DateTime.now
      @trip.save!
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
