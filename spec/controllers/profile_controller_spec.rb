require "rails_helper"

RSpec.describe ProfileController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:article) { create(:article, user: user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    context "when user exists" do
      it "renders the show template" do
        get :show, params: { id: user.id }
        expect(response).to render_template(:show)
      end
    end

    context "when user does not exist" do
      it "redirects to root path" do
        get :show, params: { id: -1 }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #followers" do
    before { other_user.follow(user) }

    it "renders the relationships_list template" do
      get :followers, params: { id: user.id }
      expect(response).to render_template("relationships_list")
    end
  end

  describe "GET #following" do
    before { user.follow(other_user) }

    it "renders the relationships_list template" do
      get :following, params: { id: user.id }
      expect(response).to render_template("relationships_list")
    end
  end
end
