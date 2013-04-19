class HomeController < ApplicationController
  def index
    @feature = Feature.first
    if @feature == nil
      redirect_to new_feature_path, notice: "请至少创建一个专题。"
      return
    end
    @diaocha = Category.diaocha.articles.with_img.hottest.first || Category.diaocha.articles.hottest.first
    @guandian = Category.guandian.articles.hottest
    @renwu = Category.renwu.articles.with_img.hottest.first || Category.renwu.articles.hottest.first
    @yuedu = Category.yuedu.articles.hottest
    @vote = Vote.first
    @most_read = Article.hottest
  end
end
