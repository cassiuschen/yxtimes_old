module ApplicationHelper

  def current_user
    begin
      User.find(session[:cas_user]) 
    rescue Mongoid::Errors::InvalidFind
      return false
    end
  end
end
