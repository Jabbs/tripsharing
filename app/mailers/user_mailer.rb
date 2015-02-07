class UserMailer < ActionMailer::Base
  default from: "#{ENV['APP_ROOT_NAME']} <no-reply@tripsharing.com>"
  default content_type: "text/html"
  
  def password_reset_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Reset your password")
    @user.password_reset_sent_at = DateTime.now
    @user.save
  end
  
  def verification_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Verify your TripSharing Account")
    @user.verification_sent_at = DateTime.now
    @user.save
  end
  
  def welcome_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Welcome to TripSharing!")
    @user.welcome_sent_at = DateTime.now
    @user.save
  end
  
end
