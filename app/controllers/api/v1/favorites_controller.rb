module Api::V1
  class FavoritesController < ApiController
    before_action :load_article, only: [:create, :destroy]

    def create
      @current_user.like @article
      render json: {success: true, message: Settings.msg.article_favorited},
             status: :created
    end

    def destroy
      @current_user.unlike @article
      render json: {success: true, message: Settings.msg.article_unfavorited},
             status: :ok
    end

    private

    def load_article
      @article = Article.find_by(id: params[:article_id])
      return if @article

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end
  end
end
