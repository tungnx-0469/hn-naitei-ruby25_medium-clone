class CommentsController < ApplicationController
  before_action :set_article

  def create
    @new_comment = @article.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      @comment = @article.comments.build
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to request.referer }
      end
    else
      render turbo_stream: turbo_stream.replace(
        "new_comment",
        partial: "comments/form"
      )
    end
  end

  private
  def comment_params
    params.require(:comment).permit(Comment::PERMMIT_PARAMS)
  end

  def set_article
    @article = Article.find_by(id: params[:article_id])
    return if @article.present?

    flash[:alert] = t "common.article_not_found"
    redirect_to root_path
  end
end
