# spec/controllers/favorites_controller_spec.rb
require "rails_helper"

RSpec.describe FavoritesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
    request.env["HTTP_REFERER"] = article_path(article)
  end

  describe "POST #create" do
    context "when article is not favorited yet" do
      it "creates a favorite and redirects to article page" do
        expect {
          post :create, params: { article_id: article.id }, format: :html
        }.to change(Favorite, :count).by(1)

        expect(response).to redirect_to(article_path(article))
      end

      it "enqueues notification if not self-liked" do
        allow(UserNotiJob).to receive(:perform_async)
        article.update(user: other_user)

        post :create, params: { article_id: article.id }, format: :html

        expect(UserNotiJob).to have_received(:perform_async).with(
          other_user.id,
          I18n.t("notification.article_favorited", article: article.title),
          "Article",
          article.id
        )
      end

      it "does not enqueue notification for self-like" do
        allow(UserNotiJob).to receive(:perform_async)
        article.update(user: user)

        post :create, params: { article_id: article.id }, format: :html

        expect(UserNotiJob).not_to have_received(:perform_async)
      end

      it "renders turbo_stream" do
        post :create, params: { article_id: article.id }, format: :turbo_stream
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when article is already favorited" do
      before { user.like(article) }

      it "does not create a duplicate and redirects back with notice" do
        expect {
          post :create, params: { article_id: article.id }, format: :html
        }.not_to change(Favorite, :count)

        expect(flash[:notice]).to eq I18n.t("msg.article_already_favorited")
        expect(response).to redirect_to(article_path(article))
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:favorite) { user.like(article) }

    it "removes the favorite and redirects to article" do
      expect {
        delete :destroy, params: { article_id: article.id, id: favorite.id }, format: :html
      }.to change(Favorite, :count).by(-1)

      expect(response).to redirect_to(article_path(article))
    end

    it "renders turbo_stream" do
      delete :destroy, params: { article_id: article.id, id: favorite.id }, format: :turbo_stream
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end
end
