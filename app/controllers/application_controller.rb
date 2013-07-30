require 'net/http'

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
    current_user && current_user.is_admin?
  end

  def is_reporter?
    current_user && current_user.is_reporter?
  end

  def cas_gateway_filter
    return if @has_already_filter
    if cookies[:tgt] or params[:ticket]
      CASClient::Frameworks::Rails::Filter.filter(self)
      @has_already_filter = true
    elsif params[:reg]
      # validate the reg
      begin
        result = Net::HTTP.get(URI.parse("http://123.116.118.254:3000/yxtimes_validate?token=" + params[:reg]))
      rescue Errno::ECONNREFUSED
        flash.now[:error] = "注册系统登录出现异常。"
        return
      end
      result = JSON.parse(result)
      if result["code"] == 1 && result["id"]
        session[:cas_user] = result["id"]
        session[:user_nickname] = result["username"]
        flash.now[:success] = "欢迎登录银杏时报。"
        @has_already_filter = true
      else
        flash.now[:error] = "登录链接已经失效。"
        return
      end
    end
  end

  def cas_filter
    return if @has_already_filter
    session[:user_nickname] || CASClient::Frameworks::Rails::Filter.filter(self)
    @has_already_filter = true
  end

  def cas_user
    if session[:cas_user]
      begin
        @current_user = User.find(session[:cas_user])
      rescue Mongoid::Errors::DocumentNotFound
        @current_user = User.create!(name: session[:cas_user], last_sign_in_at: session[:previous_redirect_to_cas], last_sign_in_ip: request.remote_ip)
        @current_user.update_attributes!(nickname: session[:user_nickname]) if session[:user_nickname]
        redirect_to root_path, flash: { success: "您第一次登录系统，请点击右侧边栏修改个人资料." }
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
