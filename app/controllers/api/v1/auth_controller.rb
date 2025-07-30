module Api::V1
  class AuthController < ApiController
    skip_before_action :authenticate, only: [:login, :register, :refresh_token]

    def register
      @user = User.new params.require(:user).permit(
        User::USER_REGISTER_PERMITTED_ATTRIBUTES
      )
      if @user.save
        generate_token(@user)
        render json: {
                 status: :success,
                 data: {
                   token: @token,
                   user: UserSerializer.new(@user)
                 }
               },
               status: :created
      else
        render json: {success: false, data: @user.errors}, status: :bad_request
      end
    end

    def login
      @user = User.find_by email: params[:user][:email]&.downcase
      if @user&.valid_password?(params[:user][:password])
        generate_token(@user)
        render json: {
                 status: :success,
                 data: {
                   token: @token,
                   user: UserSerializer.new(@user)
                 }
               },
               status: :ok
      else
        render json: {status: error, data: nil}, status: :unauthorized
      end
    end

    def my_profile
      render json: {
               success: true,
               data: {
                 user: UserSerializer.new(@current_user)
               }
             },
             status: :ok
    end

    def update_profile
      if @current_user.update(params.require(:user).permit(User::USER_UPDATE_PERMITTED_ATTRIBUTES))
        render json: {
                 success: true,
                 data: {
                   user: UserSerializer.new(@current_user)
                 }
               },
               status: :ok
      else
        render json: {success: false, data: @current_user.errors},
               status: :bad_request
      end
    end

    def refresh_token
      refresh_token = request.headers["Authorization"]&.split(" ")&.last
      payload = JsonWebToken.decode(refresh_token)

      unless payload[:type] == "refresh"
        return render json: {success: false, message: "Invalid token type"},
                      status: :unauthorized
      end

      user = User.find_by(id: payload[:user_id])
      unless user
        return render json: {success: false, message: "User not found"},
                      status: :not_found
      end

      access_payload = {
        user_id: user.id,
        type: "access"
      }
      access_token = JsonWebToken.encode(access_payload, 15.minutes.from_now)
      render json: {
        success: true,
        data: {
          access_token: access_token,
          token_type: "Bearer"
        }
      }, status: :ok
    end

    private
    def generate_token user
      access_payload = {
        user_id: user.id,
        type: "access"
      }

      refresh_payload = {
        user_id: user.id,
        type: "refresh"
      }

      access_token = JsonWebToken.encode(access_payload, 15.minutes.from_now)
      refresh_token = JsonWebToken.encode(refresh_payload, 30.days.from_now)

      @token = {
        access_token: access_token,
        refresh_token: refresh_token,
        token_type: "Bearer"
      }
    end
  end
end
