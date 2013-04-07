class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::GatewayFilter, :cas_user
  
  helper_method :current_user, :user_signed_in?

  private
  def cas_user
    if session[:cas_user]
      begin
        @current_user = User.find(session[:cas_user])
      rescue Mongoid::Errors::DocumentNotFound
        @current_user = User.create!(name: session[:cas_user], last_sign_in_at: session[:previous_redirect_to_cas])
        redirect_to users_edit_path, notice: "您第一次登录系统，修改个人信息."
        return
      end

      @current_user.update_attributes!(:last_sign_in_at => session[:previous_redirect_to_cas])
    end
  end

  def user_signed_in?
    !!@current_user
  end

  def current_user
    @current_user
  end

end
