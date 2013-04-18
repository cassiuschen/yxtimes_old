class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.with_img.hottest.first || Category.diaocha.articles.hottest.first
    @guandian = Category.guandian.articles.hottest
    @renwu = Category.renwu.articles.with_img.hottest.first || Category.renwu.articles.hottest.first
    @yuedu = Category.yuedu.articles.hottest
    @vote = Vote.first
    @most_read = Article.hottest
  end
end
