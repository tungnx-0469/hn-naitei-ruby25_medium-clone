require 'rails_helper'

RSpec.describe StaticPageController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #home" do
    let!(:articles) { create_list(:article, 3) }

    it "renders the home template" do
      allow(User).to receive(:recommend_users).with(nil).and_return([create(:user)])

      get :home
      expect(response).to render_template(:home)
    end
  end

  describe "GET #search_result" do
    let!(:matching_article) { create(:article, title: "Test search") }
    let!(:non_matching_article) { create(:article, title: "Other content") }

    it "renders the search_result template" do
      get :search_result, params: { q: { title_or_content_body_or_user_username_cont: "Test" } }

      expect(response).to render_template(:search_result)
    end
  end
end
