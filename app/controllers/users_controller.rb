class UsersController < ApplicationController
  prepend_before_filter :cas_filter, except: :show

  def edit
    @user = current_user
    render layout: false
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
    @user = User.find(params[:id])
  end

  def publishes
    @articles = current_user.articles.unscoped.desc(:created_at)

    render layout: false;
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

end
