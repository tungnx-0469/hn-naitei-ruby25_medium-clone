module Api::V1
  class CommentsController < ApiController
    before_action :set_article
    before_action :set_comment, only: [:update, :destroy]
    def create
      @new_comment = @article.comments.build(comment_params)
      @new_comment.user = @current_user
      if @new_comment.save
        render json: @new_comment, status: :created
      else
        render json: {errors: @new_comment.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    def update
      if @comment.update(comment_params)
        render json: @comment, status: :ok
      else
        render json: {errors: @comment.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    def destroy
      if @comment.destroy
        render json: {message: Settings.msg.comment_deleted}, status: :ok
      else
        render json: {errors: @comment.errors.full_messages},
               status: :unprocessable_entity
      end
    end

    private
    def comment_params
      params.require(:comment).permit(Comment::PERMIT_PARAMS)
    end

    def set_article
      @article = Article.find_by(id: params[:article_id])
      return if @article

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end

    def set_comment
      @comment = @article.comments.find_by(id: params[:id])
      return if @comment

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end
  end
end
