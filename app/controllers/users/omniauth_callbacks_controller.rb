class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def bdfzer
    @user = User.find_for_bdfzer_oauth auth_hash

    if !(@user.nil?)
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "bdfzer") if is_navigational_format?
    else
      session["devise.bdfzer_data"] = auth_hash
      @new_user = User.create(
        name: auth_hash.uid,
        email: auth_hash.info.email,
        provider: "bdfzer",
        uid: auth_hash.uid,
        nickname: auth_hash.info.name
      )
      @new_user.save
      sign_in_and_redirect @new_user
      set_flash_message(:notice, :success, :kind => "bdfzer") if is_navigational_format?
    end
  end

  private
  def auth_hash
  	request.env["omniauth.auth"]
  end
end
