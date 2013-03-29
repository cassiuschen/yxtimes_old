class ApplicationController < ActionController::Base
  protect_from_forgery

  def logout
    RubyCAS::Filter.logout(self)
  end


  private
  def cas_filter

    return unless RubyCAS::Filter.filter(self)

    current_user = User.all(name: session[:cas_user]).first
    redirect_to (users_new_path) and return if !current_user

    current_user.last_sign_in_at = session[:previous_redirect_to_cas] if current_user
  end
end
