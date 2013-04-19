class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.page params[:page]
  end
end
