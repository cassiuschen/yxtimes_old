class AdminController < ApplicationController
  http_basic_authenticate_with ***REMOVED***

  def update
    Setting.first.update_attributes(params[:settings])
    
    User.where(:power.gt => 10).update_attributes({{ power: 0 }, without_protection: true )
    User.find(params[:admin_ids]).update_attributes({ power: 100 }, without_protection: true)
    User.find(params[:teacher_ids]).update_attributes({ power: 10 }, without_protection: true)
  end
end
