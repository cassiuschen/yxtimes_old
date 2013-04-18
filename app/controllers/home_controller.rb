class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.hottest.first
    @guandian = Category.guandian.articles.hottest
    @renwu = Category.renwu.articles.hottest
    @yuedu = Category.yuedu.articles.hottest
    @vote = Vote.first
    @most_read = Article.hottest
  end
end
