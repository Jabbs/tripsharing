class VerificationsController < ApplicationController
  def show
    if User.find_by_verification_token(params[:id].to_s)
      @user = User.find_by_verification_token(params[:id].to_s)
      @user.update_attribute(:verified, true)
      sign_in @user unless current_user
      redirect_to @user, notice: "Your email has been verified."
    else
      redirect_to root_path, notice: "There was a problem verifying your account. Please contact support@tripsharing.com 
                                     for more details."
    end
  end
  
  def unsubscribe
    if @user = User.find_by_verification_token(params[:unsubscribe_id].to_s)
      @user.unsubscribe_from(params[:email_type])
      redirect_to root_path, notice: "You have been unsubscribed from these types of emails."
    else
      redirect_to root_path, notice: "There was a problem unsubscribing your email. Please contact support@tripsharing.com 
                                     for more details."
    end
  end
  
  def resend
    @user = User.friendly.find(params[:user_id])
    UserMailer.delay.user_verification_email(@user)
    redirect_to @user, notice: "A verification email has been sent. Please click on the link to verify your account.
                                Check your spam folder if you are still having issues or contact our support team."
  end
end
