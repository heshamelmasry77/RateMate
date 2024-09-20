module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized, only: [ :create ]

      def create
        user = User.new(user_params)
        if user.save
          token = encode_token({ user_id: user.id })
          render json: { user: user_response(user), jwt: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :password)
      end
    end
  end
end
