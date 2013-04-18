class ArticlesController < ApplicationController
  prepend_before_filter :cas_filter, except: :show
  append_before_filter :require_admin, only: [:index, :verify]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.un_verified

    respond_to do |format|
      format.html {
        if params[:raw]
          render layout: false
        else
          render
        end
      } # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.unscoped.find(params[:id])

    if !@article.is_verified? and (@article.author != current_user) and !current_user.is_admin?
      raise ActionController::RoutingError.new('Not Found')
    end

    @article.read

    @comment = Comment.new
    @subcomment = SubComment.new
    
    respond_to do |format|
      format.html {
        if params[:raw]
          render layout: false
        else
          render
        end
      }
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new
    @article.category_id = params[:category] if params[:category]

    if params[:raw]
      render layout: false
    else
      render
    end

  end

  # GET /articles/1/edit
  def edit
    @article = Article.unscoped.find(params[:id])

    unless current_user.is_admin? or (current_user == @article.author and !@article.is_verified?)
      raise ActionController::RoutingError.new('Not Found')
    end
    
    if params[:raw]
      render layout: false
    else
      render
    end

  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article].merge({ author: current_user }))

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.unscoped.find(params[:id])

    unless current_user.is_admin? or (current_user == @article.author and !@article.is_verified?)
      raise ActionController::RoutingError.new('Not Found')
    end

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /articles/1/delete
  # GET /articles/1/delete.json
  def destroy
    @article = Article.unscoped.find(params[:id])
    @category = @article.category

    unless current_user.is_admin? or (current_user == @article.author and !@article.is_verified?)
      raise ActionController::RoutingError.new('Not Found')
    end

    @article.destroy

    respond_to do |format|
      format.html { 
        if params[:raw]
          redirect_to articles_url, flash: { success: "删除成功" }
        else
          redirect_to @category, flash: { success: "删除成功" }
        end
      }
      format.json { head :no_content }
    end
  end


  def follow
    @article = Article.find(params[:id])
    @article.starrers.push current_user

    current_user.send_feed("关注了 <a href='#{category_path(@article.category)}' class='link'>#{@article.category.name}</a> 中的文章<a href='#{article_path(@article)}' class='timeline-link'>《#{@article.title}》</a>")

    redirect_to :back
  end

  def unfollow
    @article = Article.find(params[:id])
    @article.starrers.delete current_user

    redirect_to :back
  end

  def verify
    @article = Article.unscoped.find(params[:id])
    @article.verify!

    @article.author.send_feed("在 <a href='#{category_path(@article.category)}' class='link'>#{@article.category.name}</a> 中发布了文章<a href='#{article_path(@article)}' class='timeline-link'>《#{@article.title}》</a>")

    redirect_to articles_path(raw: true)
  end
end
