class UserMailer < ActionMailer::Base
  default from: "#{ENV['APP_ROOT_NAME']} <no-reply@tripsharing.com>"
  default content_type: "text/html"
  
  def user_password_reset_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Reset your password")
    @user.password_reset_sent_at = DateTime.now
    @user.save
  end
  
  def trip_d_email(user, trip)
    @trip = trip
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Your new Trip on Tripsharing")
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
