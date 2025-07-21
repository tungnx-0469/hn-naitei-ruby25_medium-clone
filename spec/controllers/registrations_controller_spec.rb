require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET #edit" do
    context "when user has permission" do
      it "renders the edit template" do
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    context "when user has no permission" do
      before do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "redirect to root path" do
        get :edit
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the user and redirects" do
        patch :update, params: { user: { username: "new_name", current_password: user.password } }
        expect(response).to redirect_to(root_path)
        expect(user.reload.username).to eq("new_name")
      end
    end

    context "without current_password" do
      it "does not update the user" do
        patch :update, params: { user: { username: "no_change" } }
        expect(user.reload.username).not_to eq("no_change")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user account and redirects" do
      expect {
        delete :destroy, params: { user: { current_password: user.password } }
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(root_path)
    end
  end
end
