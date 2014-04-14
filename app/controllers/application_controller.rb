require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  #before_filter :cas_gateway_filter, :cas_user

  #helper_method :current_user, :user_signed_in?, :is_admin?, :is_reporter?, :can_vote?, :omniauth_login
  helper_method :is_admin?, :is_reporter?, :can_vote?

  private

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_up) << [:name, :nickname]
    #devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :email) }
  end

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

  def can_vote? vote
    if vote.is_disabled
      false
    elsif current_user
      !vote.voters.include?(current_user)
    elsif vote.allow_anonymous and cookies[:_yxtimes_session]
      if !cookies[:_yxtimes_vid]
        cookies[:_yxtimes_vid] = {}
        cookies[:_yxtimes_vid] = { :value => SecureRandom.hex(10), :expires => 1.year.from_now }
      end
      vote_id_list = Rails.cache.fetch(["vote_record", cookies[:_yxtimes_vid]]) { [] }
      !vote_id_list.include?(vote.id)
    else
      false
    end
  end

#  def cas_gateway_filter
#    return if @has_already_filter
#    if cookies[:tgt] or params[:ticket]
#      CASClient::Frameworks::Rails::Filter.filter(self)
#      @has_already_filter = true
#    elsif params[:reg]
#      # validate the reg
#      begin
#        result = Net::HTTP.get(URI.parse("http://localhost:9000/yxtimes_validate?token=" + params[:reg]))
#      rescue Errno::ECONNREFUSED
#        flash.now[:error] = "注册系统登录出现异常。"
#        return
#      end
#      result = JSON.parse(result)
#      if result["code"] == 1 && result["id"]
#        session[:cas_user] = result["id"]
#        session[:user_nickname] = result["username"]
#        flash.now[:success] = "欢迎登录银杏时报。"
#        @has_already_filter = true
#      else
#        flash.now[:error] = "登录链接已经失效。"
#        return
#      end
#    end
#  end

#  def cas_filter
#    return if @has_already_filter
#    session[:user_nickname] || CASClient::Frameworks::Rails::Filter.filter(self)
#    @has_already_filter = true
#  end

#  def omniauth_filter
#    return if @has_already_filter
#    session[:user_nickname] || omniauth_login
#    @has_already_filter = true
#  end

#  def cas_user
#    if session[:cas_user]
#      begin
#        @current_user = User.find(session[:cas_user])
#      rescue Mongoid::Errors::DocumentNotFound
#        @current_user = User.create!(name: session[:cas_user], last_sign_in_at: session[:previous_redirect_to_cas], last_sign_in_ip: request.remote_ip)
#        @current_user.update_attributes!(nickname: session[:user_nickname]) if session[:user_nickname]
#        redirect_to root_path, flash: { success: "您第一次登录系统，请点击右侧边栏修改个人资料." }
#        return
#      end

#      @current_user.update_attributes!(last_sign_in_at: session[:previous_redirect_to_cas], last_sign_in_ip: request.remote_ip)
#    end
#  end

#  def omniauth_login
#    begin
#        @current_user = User.find(auth_hash['uid'])
#        session[:user_nickname] = current_user.nickname
#        session[:user_id] = current_user.name
#        redirect_to root_path, flash: { success: "登录成功！欢迎你，#{current_user.nickname}!" }
#      rescue Mongoid::Errors::DocumentNotFound
#        @current_user = User.create!(_id: auth_hash['uid'], name: auth_hash['uid'], last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
#        @current_user.update_attributes!(nickname: auth_hash['info']['name'])
#        session[:user_nickname] = @current_user.nickname
#        session[:user_id] = current_user.name
#        redirect_to root_path, flash: { success: "您第一次登录系统，请点击右侧边栏修改个人资料." }
#        return
#      end

#      @current_user.update_attributes!(last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
#  end

#  def user_signed_in?
#    !!@current_user
#  end

#  def current_user
#    begin
#    @current_user ||= User.find(session[:user_id])
#    rescue Mongoid::Errors::InvalidFind
#      return
#    end
#  end

#  private
#  def auth_hash
#    request.env['omniauth.auth']
#  end
end
