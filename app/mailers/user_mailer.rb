class UserMailer < ActionMailer::Base
  default from: "#{ENV['APP_ROOT_NAME']} <no-reply@tripfloat.com>"
  default content_type: "text/html"
  
  def password_reset_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "#{ENV['APP_ROOT_NAME']} - Password Reset")
    @user.password_reset_sent_at = DateTime.now
    @user.save
  end
  
  def verification_email(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Verify your TripFloat Account")
    @user.verification_sent_at = DateTime.now
    @user.save
  end
end
