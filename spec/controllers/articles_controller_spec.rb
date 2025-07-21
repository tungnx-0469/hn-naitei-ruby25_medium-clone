require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: article.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    before { sign_in user }

    it "renders the edit template" do
      get :edit, params: { id: article.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    before { sign_in user }

    context "with valid params" do
      it "creates a new article and redirects" do
        article_params = attributes_for(:article)
        post :create, params: { article: article_params }
        expect(response).to redirect_to(profile_path(user))
      end
    end

    context "with invalid params" do
      it "fails and redirects with unprocessable_entity" do
        post :create, params: { article: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    before { sign_in user }

    context "with valid params" do
      it "updates the article and redirects" do
        patch :update, params: { id: article.id, article: { title: "Updated" } }
        expect(response).to redirect_to(article)
      end
    end

    context "with invalid params" do
      it "renders edit with error" do
        patch :update, params: { id: article.id, article: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in user }
    let!(:article_to_delete) { create(:article, user: user) }

    context "when destroy succeeds" do
      it "redirects to profile with notice" do
        delete :destroy, params: { id: article_to_delete.id }
        expect(response).to redirect_to(profile_path(user))
      end
    end

    context "when destroy fails" do
      before do
        allow_any_instance_of(Article).to receive(:destroy).and_return(false)
      end

      it "redirects with alert" do
        delete :destroy, params: { id: article_to_delete.id }
        expect(response).to redirect_to(profile_path(user))
      end
    end
  end
end
