class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.with_img.hottest.first
    @guandian = Category.guandian.articles.with_img.hottest
    @renwu = Category.renwu.articles.with_img.hottest
    @yuedu = Category.yuedu.articles.with_img.hottest
    @vote = Vote.first
    @most_read = Article.hottest
  end
end
