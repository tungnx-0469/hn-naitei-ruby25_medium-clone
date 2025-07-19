class FavoritesController < ApplicationController
  before_action :load_article

  def create
    current_user.like(@article)
    respond_to do |format|
      format.html { redirect_to article_path(@article) }
      format.turbo_stream
    end
  end

  def destroy
    current_user.unlike(@article)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to article_path(@article) }
    end
  end

  def load_article
    @article = Article.find_by(id: params[:article_id])
    return if @article

    flash[:alert] = t "msg.article_not_found"
    redirect_to root_path
  end
end
