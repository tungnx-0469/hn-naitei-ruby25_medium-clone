require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe "POST #read" do
    let!(:notification) { create(:notification, user: user, notifiable: article, read: false) }

    context "when user is signed in" do
      before do
        sign_in user
        post :read, params: { id: notification.id }
        notification.reload
      end

      it "marks notification as read" do
        expect(notification.read).to be true
      end

      it "redirects to direct path based on notifiable type" do
        expect(response).to redirect_to(article_path(article))
      end
    end

    context "when notification is already read" do
      before do
        notification.update(read: true)
        sign_in user
        post :read, params: { id: notification.id }
      end

      it "does not update the notification again but still redirects" do
        expect(response).to redirect_to(article_path(article))
      end
    end
  end

  describe "DELETE #delete_all" do
    let!(:noti1) { create(:notification, user: user) }
    let!(:noti2) { create(:notification, user: user) }

    context "when user is signed in" do
      before do
        sign_in user
        request.env["HTTP_REFERER"] = root_path
      end

      it "deletes all notifications of the current user" do
        expect {
          delete :delete_all
        }.to change(Notification, :count).by(-2)
      end

      it "redirects to the referer" do
        delete :delete_all
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not authorized" do
      before do
        sign_in other_user
      end

      it "redirects to the root path" do
        delete :delete_all
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
