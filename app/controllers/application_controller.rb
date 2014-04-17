require 'net/http'

class ApplicationController < ActionController::Base
  protect_from_forgery unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

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
end
