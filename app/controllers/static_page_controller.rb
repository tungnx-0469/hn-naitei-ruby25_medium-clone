class StaticPageController < ApplicationController
  def home
    @users = User.recommend_users current_user
    @pagy, @articles = pagy Article.recent.includes(:user, :comments),
                            limit: Settings.article_per_page
  end

  def search_result
    @pagy, @articles = pagy @q.result.includes(:user).recent,
                            limit: Settings.article_per_page
    render :search_result
  end
end
