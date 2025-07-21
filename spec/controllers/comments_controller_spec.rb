# spec/controllers/comments_controller_spec.rb
require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:comment_params) { attributes_for(:comment) }

  before do
    sign_in user
    request.env["HTTP_REFERER"] = article_path(article)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new comment and returns turbo_stream" do
        expect {
          post :create, params: { article_id: article.id, comment: comment_params }, format: :turbo_stream
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "renders the form again" do
        invalid_params = { content: "" }
        post :create, params: { article_id: article.id, comment: invalid_params }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET #edit" do
    let(:comment) { create(:comment, article: article, user: user) }

    it "returns the edit form as turbo_stream" do
      get :edit, params: { article_id: article.id, id: comment.id }, format: :turbo_stream
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    let(:comment) { create(:comment, article: article, user: user) }

    context "with valid params" do
      it "updates the comment and redirects" do
        patch :update, params: {
          article_id: article.id,
          id: comment.id,
          comment: { content: "Updated content" }
        }, format: :turbo_stream

        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "redirects with error" do
        patch :update, params: {
          article_id: article.id,
          id: comment.id,
          comment: { content: "" }
        }
        expect(response).to redirect_to(article_path(article))
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, article: article, user: user) }

    it "deletes the comment and returns turbo_stream" do
      expect {
        delete :destroy, params: { article_id: article.id, id: comment.id }, format: :turbo_stream
      }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
