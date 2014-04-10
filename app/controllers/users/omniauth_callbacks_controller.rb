class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def bdfzer
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

  def self.find_for_bdfzer_oauth(auth)
  	where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
    end
  end
end