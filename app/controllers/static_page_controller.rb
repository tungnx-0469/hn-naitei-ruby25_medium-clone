class StaticPageController < ApplicationController
  def home
    @users = User.recommend_users current_user
    @articles = Article.recent
  end
end
