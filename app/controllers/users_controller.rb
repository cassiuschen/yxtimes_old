class UsersController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter, except: :show
  prepend_before_filter CASClient::Frameworks::Rails::Filter, except: :show

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

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def show
    
  end

end
