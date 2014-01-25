module SessionsHelper
  def sign_in(user)
    cookies[:auth_token] = user.auth_token
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token])
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def admin_user?
    true if current_user && current_user.admin?
  end
  
  def signed_in_user
    unless current_user
      store_location
      redirect_to login_url, alert: "Please log in first."
    end
  end
  
  def verified_user
    redirect_to current_user, alert: 'Please verify your account first.' unless current_user.verified
  end
  
  def complete_user
    redirect_to current_user, alert: 'Please complete your profile first.' if current_user.incomplete?
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.url
  end
end
