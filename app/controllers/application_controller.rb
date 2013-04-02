class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :user_signed_in?

  private
  def cas_filter

    return unless RubyCAS::Filter.filter(self)
    
    begin
      @current_user = User.find(session[:cas_user])
    rescue Mongoid::Errors::DocumentNotFound
      @current_user = nil
      redirect_to(users_new_path) and return
    end

    @current_user.update_attribute(last_sign_in_at: session[:previous_redirect_to_cas])
  end

  def user_signed_in?
    !!@current_user
  end

  def current_user 
    @current_user
  end
end
