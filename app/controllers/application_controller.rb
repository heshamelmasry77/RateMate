class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    payload[:exp] = 45.minutes.from_now.to_i
    JWT.encode(payload, secret_key, "HS256")
  end

  def secret_key
    Rails.application.credentials.secret_key_base
  end

  def auth_header
    request.headers["Authorization"]
  end

  def decoded_token
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, secret_key, true, algorithm: "HS256")
      rescue JWT::DecodeError, JWT::ExpiredSignature
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    if logged_in?
      # Proceed as normal
    else
      render json: { errors: [ "Please log in" ] }, status: :unauthorized
    end
  rescue JWT::ExpiredSignature
    render json: { errors: [ "Your session has expired. Please log in again." ] }, status: :unauthorized
  end

  private

  def user_response(user)
    {
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
