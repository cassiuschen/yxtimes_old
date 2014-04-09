class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def bdfzer
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    
    @user = User.find_for_bdfzer_oauth auth_hash

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "bdfzer") if is_navigational_format?
    else
      session["devise.bdfzer_data"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  private
  def auth_hash
  	request.env["omniauth.auth"]
  end
end