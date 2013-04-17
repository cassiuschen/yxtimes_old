class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :cas_gateway_filter, :cas_user
  
  helper_method :current_user, :user_signed_in?, :is_admin?, :is_reporter?

  private

  def require_admin
    unless current_user && current_user.is_admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def is_admin?
    current_user.is_admin?
  end

  def is_reporter?
    current_user.is_reporter?
  end

  def cas_gateway_filter
    return if @has_already_filter
    if cookies[:tgt]
      CASClient::Frameworks::Rails::Filter.filter(self)
      @has_already_filter = true
    end
  end

  def cas_filter
    return if @has_already_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
    @has_already_filter = true
  end

  def cas_user
    if session[:cas_user]
      begin
        @current_user = User.find(session[:cas_user])
      rescue Mongoid::Errors::DocumentNotFound
        @current_user = User.create!(name: session[:cas_user], last_sign_in_at: session[:previous_redirect_to_cas])
        redirect_to users_edit_path, notice: "您第一次登录系统，修改个人信息."
        return
      end

      @current_user.update_attributes!(last_sign_in_at: session[:previous_redirect_to_cas], last_sign_in_ip: request.remote_ip)
    end
  end

  def user_signed_in?
    !!@current_user
  end

  def current_user
    @current_user
  end

end
