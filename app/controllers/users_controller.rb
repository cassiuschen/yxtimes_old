class UsersController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:show, :login]

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


  def login
    begin
        @current_user = User.find(auth_hash['uid'])
        session[:user_nickname] = current_user.nickname
        session[:user_id] = current_user.name
        redirect_to root_path, flash: { success: "登录成功！欢迎你，#{current_user.nickname}!" }
      rescue Mongoid::Errors::DocumentNotFound
        @current_user = User.create!(_id: auth_hash['uid'], name: auth_hash['uid'], last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
        @current_user.update_attributes!(nickname: auth_hash['info']['name'])
        session[:user_nickname] = @current_user.nickname
        session[:user_id] = current_user.name
        redirect_to root_path, flash: { success: "您第一次登录系统，请点击右侧边栏修改个人资料." }
        return
      end

      @current_user.update_attributes!(last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip)
  end
end
