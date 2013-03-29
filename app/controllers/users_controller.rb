class UsersController < ApplicationController
  before_filter :cas_filter, except: "new"

  def new
    return if User.exists?(name: session[:cas_user])

    @user = User.create({name: session[:cas_user]})
    render action: "edit", notice: '您第一次登录系统，修改个人信息.'
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    params[:user].delete("name")

    if @user.update_attributes(params[:user])
      redirect_to root_path, notice: "profile was successfully update."
    else
      render action: "edit"
    end
  end
end
