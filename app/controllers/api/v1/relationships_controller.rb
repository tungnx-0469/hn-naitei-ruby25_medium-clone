module Api::V1
  class RelationshipsController < ApiController
    before_action :load_relationship, only: [:destroy]
    before_action :load_user, only: [:create]
    def create
      @current_user.follow(@user)
      UserNotiJob.perform_async(
        @user.id,
        t("notification.user_followed", user: @current_user.username),
        "User",
        @current_user.id
      )
      render json: {success: true, message: Settings.msg.follow_success},
             status: :created
    end

    def destroy
      @current_user.unfollow(@user)
      UserNotiJob.perform_async(
        @user.id,
        t("notification.user_unfollowed", user: @current_user.username),
        "User",
        @current_user.id
      )
      render json: {success: true, message: Settings.msg.unfollow_success},
             status: :ok
    end

    private
    def load_relationship
      @relationship = Relationship.find_by(id: params[:id])
      return if @relationship

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end

    def load_user
      @user = User.find_by id: params[:followed_id]
      return if @user

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end
  end
end
