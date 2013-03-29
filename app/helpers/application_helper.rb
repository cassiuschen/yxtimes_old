module ApplicationHelper
  def user_sign_in?
    session[:cas_user] && User.exists?(name: session[:cas_user])
  end
  def current_user
    User.all(name: session[:cas_user]).first
  end
end
