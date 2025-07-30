module Api::V1
  class NotificationsController < ApiController
    def index
      @notifications = @current_user.notifications.recent
      render json: {
        data: {
          notifications: @notifications
        },
        status: :success
      }, status: :ok
    end
  end
end
