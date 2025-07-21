require "rails_helper"

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "when successful" do
      it "creates relationship and renders template" do
        post :create, params: { followed_id: other_user.id }, format: :turbo_stream
        expect(response).to render_template :create
      end
    end

    context "when followed_id is missing" do
      it "redirects to root with alert flash" do
        post :create, params: { followed_id: nil }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when followed_id is invalid" do
      it "redirects to root with alert flash" do
        post :create, params: { followed_id: -1 }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:relationship) do
      user.follow(other_user)
      user.active_relationships.find_by(followed_id: other_user.id)
    end

    context "when successful" do
      it "removes relationship and renders template" do
        delete :destroy, params: { id: relationship.id }, format: :turbo_stream
        expect(response).to render_template :destroy
      end
    end

    context "when id is missing or not found" do
      it "redirects to root with alert flash" do
        delete :destroy, params: { id: -1 }, format: :turbo_stream
        expect(response).to redirect_to(root_path)
      end
    end

    context "when relationship does not belong to current_user" do
      let(:third_user) { create(:user) }
      let!(:relationship_not_owned) do
        third_user.follow(user)
        third_user.active_relationships.find_by(followed_id: user.id)
      end

      it "redirects to root if relationship not owned by current user" do
        allow(controller).to receive(:current_user).and_return(other_user)
        delete :destroy, params: { id: relationship.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
