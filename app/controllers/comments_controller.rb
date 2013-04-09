class CommentsController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter
  prepend_before_filter CASClient::Frameworks::Rails::Filter
 
  def create
    @commentable = params[:article_id] ? Article.find(params[:article_id]) : Vote.find(params[:vote_id])

    respond_to do |format|
      if @commentable.comments.create!(params[:comment].merge({commenter: current_user}))
        format.html { redirect_to @commentable, notice: "Comment successfully." }
        format.json { render json: { success: false }, status: :created }
      else
        format.html { redirect_to @commentable, notice: "Comment error."}
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
  end

  def create_subcomment

  end

  def destroy_subcomment
    
  end
end
