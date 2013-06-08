class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.with_img.recent.first || Category.diaocha.articles.hottest.first
    @guandian = Category.guandian.articles.recent
    @renwu = Category.renwu.articles.with_img.recent.first || Category.renwu.articles.hottest.first
    @yuedu = Category.yuedu.articles.recent
    @vote = Vote.first
    @most_read = Article.hottest
  end

  def about
    @about = Setting.first.about

    render layout: false
  end
end
