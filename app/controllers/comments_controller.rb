class CommentsController < ApplicationController
  before_filter :cas_filter
  append_before_filter :require_admin, only: [:destroy, :destroy_subcomment]

  def show
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])

    respond_to do |format|
      format.html { redirect_to(url_for(@commentable)+"#comments") }
      format.json { render json: @commentable.comments.to_json }
    end
  end
 
  def create
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @commentable.starrers << current_user if params[:article_id]

    respond_to do |format|
      if @commentable.comments.new(params[:comment].merge(commenter: params[:anonymous].present? ? nil : current_user).merge(ip: request.remote_ip)).save
        format.html { redirect_to @commentable, anchor: "comments" , flash: { success: "评论成功" } }
        format.json { render json: { success: false }, status: :created }
      else
        format.html { redirect_to @commentable, flash: { error: "评论失败" } }
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, flash: { success: "删除成功" } } 
      format.json { head :no_content }
    end
  end

  def create_subcomment
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:comment_id])

    @commentable.starrers << current_user if params[:article_id]

    respond_to do |format|
      if @comment.subcomments.new(params[:sub_comment].merge(commenter: params[:anonymous].present? ? nil : current_user).merge(ip: request.remote_ip)).save
        format.html { redirect_to @commentable, flash: { success: "评论成功" } }
        format.json { render json: { success: false }, status: :created }
      else
        format.html { redirect_to @commentable, flash: { error: "评论失败" }}
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def destroy_subcomment
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:comment_id])
    @subcomment = @comment.subcomments.find(params[:id])

    @subcomment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, flash: { success: "删除成功" } } 
      format.json { head :no_content }
    end
  end

end
