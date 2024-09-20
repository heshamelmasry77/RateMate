module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorized, only: [ :create ]

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { user: user_response(user), jwt: token }, status: :accepted
        else
          render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
        end
      end
    end
  end
end
