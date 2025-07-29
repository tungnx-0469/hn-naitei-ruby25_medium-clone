module Api::V1
  class ProfilesController < ApiController
    skip_before_action :authenticate
    before_action :set_profile, only: [:show, :followers, :following]

    def index
      @profiles = @profile_q.result
      render json: {
        data: {
          profiles: @profiles
        },
        status: :success
      }, status: :ok
    end

    def show
      render json: {
        data: {
          profile: @profile.as_json(
            include: :articles
          )
        }
      }, status: :ok
    end

    def followers
      @followers = @profile.followers
      render json: {
        data: {
          followers: @followers.as_json(
            only: [:id, :username, :avatar]
          )
        },
        status: :success
      }
    end

    def following
      @following = @profile.following
      render json: {
        data: {
          following: @following.as_json(
            only: [:id, :username, :avatar]
          )
        },
        status: :success
      }
    end

    private
    def set_profile
      @profile = User.find_by(id: params[:id])
      return if @profile

      render json: {success: false, message: Settings.msg.record_not_found},
             status: :not_found
    end
  end
end
