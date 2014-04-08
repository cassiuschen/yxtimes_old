class UsersController < ApplicationController
  #prepend_before_filter :cas_filter, except: :show,

  def edit
    @user = current_user
    if params[:raw]
      render layout: false
    else
      render
    end
  end

  def update
    @user = current_user
    params[:user].delete("name")

    if @user.update_attributes(params[:user])
      redirect_to root_path
    else
      render action: "edit"
    end
  end

  def logout
    cookies.delete(:tgt)
    if session[:user_nickname]
      session.delete(:cas_user)
      session.delete(:user_nickname)
      redirect_to root_path
    else
      CASClient::Frameworks::Rails::Filter.logout(self)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def publishes
    @articles = current_user.articles.unscoped.recent

    if params[:raw]
      render layout: false
    else
      render
    end
  end

  def show_feeds
    @user = User.find(params[:id])
    @feeds = @user.feeds.page params[:page]
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.json { render json: @feeds }
    end
  end

  def show_articles
    @user = User.find(params[:id])
    @articles = @user.articles.page params[:page]
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.json { render json: @articles }
    end
  end

  def noti
    @noti = current_user.notifications.find(params[:id])
    @noti.read

    redirect_to @noti.link
  end

  def omniauth_login
    @user = User.find(auth_hash['uid']) || User.create!(
      _id: auth_hash['uid'],
      name: auth_hash['info']['name']
    )
    self.current_user = @user
    redirect_to root_path
  end

  private
  def auth_hash
    request.env['omniauth.auth']
  end
end
