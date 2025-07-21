class FavoritesController < ApplicationController
  load_resource :article

  def create
    favorite = current_user.like(@article)
    unless favorite.previously_new_record?
      flash[:notice] = t "msg.article_already_favorited"
      return redirect_to request.referer || root_path
    end
    send_notification_to_author if current_user.id != @article.user.id
    respond_to do |format|
      format.html{redirect_to article_path(@article)}
      format.turbo_stream
    end
  end

  def destroy
    current_user.unlike(@article)
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_to article_path(@article)}
    end
  end

  private
  def send_notification_to_author
    UserNotiJob.perform_async(
      @article.user.id,
      t("notification.article_favorited", article: @article.title),
      "Article",
      @article.id
    )
  end
end
