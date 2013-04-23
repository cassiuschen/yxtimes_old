class AdminController < ApplicationController
  http_basic_authenticate_with ***REMOVED***

  def update
    Setting.first.update_attributes(params[:setting])

    a = params[:user_data]
    a.each_line do |line|
      arr = line.gsub(/\r|\n/,"").split(/ |,|\t/).reject(&:empty?)
      begin
        User.find(arr[0]).update_attributes({nickname: arr[1]}, without_protection: true)
      rescue Mongoid::Errors::DocumentNotFound
        User.create!(name: arr[0], nickname: arr[1])
      end
    end 

    User.where(:power.gt => 1).each { |u| u.update_attributes({ power: 0 }, without_protection: true ) }
    User.find(params[:reporter_ids]).each { |u| u.update_attributes({ power: 1 }, without_protection: true) } if params[:reporter_ids]
    User.find(params[:admin_ids]).each { |u| u.update_attributes({ power: 10 }, without_protection: true) } if params[:admin_ids]

    redirect_to :back, flash: { success: "更新成功。" }
  end

  def index
    @setting = Setting.first
    @users = User.all
  end
end
