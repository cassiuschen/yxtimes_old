class CommentsController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter
  prepend_before_filter CASClient::Frameworks::Rails::Filter
 
  def create
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])

    respond_to do |format|
      if @commentable.comments.new(params[:comment].merge({commenter: current_user})).save
        format.html { redirect_to @commentable, flash: { success: "Comment successfully." } }
        format.json { render json: { success: false }, status: :created }
      else
        format.html { redirect_to @commentable, flash: { error: "Comment error." } }
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Delete successfully." }
      format.json { head :no_content }
    end
  end

  def create_subcomment
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:comment_id])

    respond_to do |format|
      if @comment.subcomments.new(params[:sub_comment].merge({commenter: current_user})).save
        format.html { redirect_to @commentable, flash: { success: "Comment successfully." } }
        format.json { render json: { success: false }, status: :created }
      else
        format.html { redirect_to @commentable, flash: { error: "Comment error." }}
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def destroy_subcomment
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])
    @comment = @commentable.comments.find(params[:comment_id])
    @subcomment = @comment.subcomments.find(params[:id])

    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Delete successfully." }
      format.json { head :no_content }
    end
  end

end
