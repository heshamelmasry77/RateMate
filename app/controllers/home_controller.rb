class HomeController < ApplicationController
  # No need for authentication for this action
  skip_before_action :authorized

  def welcome
    render json: {
      message: "Welcome to RateMate API!",
      description: "RateMate is a currency conversion API that allows you to convert between different currencies with real-time or historical exchange rates.",
      available_endpoints: {
        user_registration: "/api/v1/users",
        user_login: "/api/v1/login",
        currency_conversion: "/api/v1/convert"
      },
      note: "Make sure to provide a valid JWT token for protected routes."
    }, status: :ok
  end
end
