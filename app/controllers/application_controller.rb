class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def cas_filter

    return unless RubyCAS::Filter.filter(self)
    
    begin
      current_user = User.find(session[:cas_user])
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to(users_new_path) and return
    end

    current_user.last_sign_in_at = session[:previous_redirect_to_cas] if current_user
  end
end
