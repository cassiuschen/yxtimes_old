class AdminController < ApplicationController
  http_basic_authenticate_with ***REMOVED***

  def update
    Setting.first.update_attributes(params[:settings])
    
    User.where(:power.gt => 1).each { |u| u.update_attributes({ power: 0 }, without_protection: true ) }
    User.find(params[:reporter_ids]).each { |u| u.update_attributes({ power: 1 }, without_protection: true) }
    User.find(params[:admin_ids]).each { |u| u.update_attributes({ power: 10 }, without_protection: true) }

    redirect_to :back, flash: { success: "更新成功。" }
  end

  def index
    @setting = Setting.new
    @users = User.all
  end
end
