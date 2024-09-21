module Api
  module V1
    class CurrencyController < ApplicationController
      skip_before_action :authorized # Skip JWT authentication for this controller TESTING

      require "http"

      def convert
        from_currency = params[:from]
        to_currency = params[:to]
        amount = params[:amount].to_f

        if from_currency.blank? || to_currency.blank? || amount.zero?
          render json: { error: "Please provide valid 'from', 'to' currencies and a non-zero 'amount'" }, status: :bad_request
          return
        end

        exchange_rate = fetch_exchange_rate(from_currency, to_currency)

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

      def fetch_exchange_rate(from_currency, to_currency)
        api_key = ENV["FIXER_API_KEY"]
        url = "https://data.fixer.io/api/latest?access_key=#{api_key}&symbols=#{from_currency},#{to_currency}"

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
