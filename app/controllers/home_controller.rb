class HomeController < ApplicationController
  def index
    @feature = Feature.first
    @diaocha = Category.diaocha.articles.with_img.hottest.first || Category.diaocha.articles.hottest.first
    @guandian = Category.guandian.articles.hottest
    @renwu = Category.renwu.articles.with_img.hottest.first || Category.renwu.articles.hottest.first
    @yuedu = Category.yuedu.articles.hottest
    @vote = Vote.first
    @most_read = Article.hottest
    unless @feature && @diaocha && @guandian && @renwu && @yuedu && @vote 
      redirect_to new_article_path, notice: "请至少每个目录创建一篇文章，否则首页无法显示"
    end
  end

  def about
    @about = Setting.first.about

    render layout: false
  end
end
