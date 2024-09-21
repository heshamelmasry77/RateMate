module Api
  module V1
    class CurrencyController < ApplicationController
      # Skip JWT authentication for this controller TESTING
      # skip_before_action :authorized
      before_action :authorized # Enforce authentication

      require "http"

      def convert
        from_currency = params[:from]
        to_currency = params[:to]
        amount = params[:amount].to_f
        date = params[:date] # Optional date input

        if from_currency.blank? || to_currency.blank? || amount.zero?
          render json: { error: "Please provide valid 'from', 'to' currencies and a non-zero 'amount'" }, status: :bad_request
          return
        end

        exchange_rate = fetch_exchange_rate(from_currency, to_currency, date)

        if exchange_rate
          converted_amount = (amount * exchange_rate).round(2)
          render json: {
            from: from_currency,
            to: to_currency,
            original_amount: amount,
            converted_amount: converted_amount,
            exchange_rate: exchange_rate
          }, status: :ok
        else
          render json: { error: "Unable to fetch exchange rate. Please check currency codes and try again." }, status: :unprocessable_entity
        end
      end

      private

      def fetch_exchange_rate(from_currency, to_currency, date = nil)
        api_key = ENV["FIXER_API_KEY"]

        # Historical rates endpoint: https://data.fixer.io/api/YYYY-MM-DD TODO Remove this line just to remember
        # Latest rates endpoint: https://data.fixer.io/api/latest TODO Remove this line just to remember
        # If a date is provided, use the historical rates endpoint
        if date
          url = "https://data.fixer.io/api/#{date}?access_key=#{api_key}&symbols=#{from_currency},#{to_currency}"
        else
          url = "https://data.fixer.io/api/latest?access_key=#{api_key}&symbols=#{from_currency},#{to_currency}"
        end

        response = HTTP.get(url)
        if response.status.success?
          data = JSON.parse(response.body.to_s)
          if data["success"]
            rates = data["rates"]
            rates[to_currency] / rates[from_currency]
          else
            nil
          end
        else
          nil
        end
      end
    end
  end
end
