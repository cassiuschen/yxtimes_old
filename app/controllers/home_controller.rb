class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.first
    @guandian = Category.guandian.articles
    @renwu = Category.renwu.articles
    @yuedu = Category.yuedu.articles
    @vote = Vote.first
  end
end
