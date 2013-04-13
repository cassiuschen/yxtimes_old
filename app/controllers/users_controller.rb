class UsersController < ApplicationController
  prepend_before_filter :cas_filter, except: :show

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    params[:user].delete("name")

    if @user.update_attributes(params[:user])
      redirect_to root_path, flash: { success: "profile was successfully update."} 
    else
      render action: "edit"
    end
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def show
    
  end

end
