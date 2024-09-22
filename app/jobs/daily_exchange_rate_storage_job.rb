class DailyExchangeRateStorageJob < ApplicationJob
  queue_as :default

  def perform
    # Fetch the latest exchange rates from the Fixer.io API
    api_key = ENV["FIXER_API_KEY"]
    url = "https://data.fixer.io/api/latest?access_key=#{api_key}"

    response = HTTP.get(url)

    if response.status.success?
      data = JSON.parse(response.body.to_s)

      if data["success"]
        rates = data["rates"]
        base_currency = data["base"]
        timestamp = data["timestamp"]

        # Store the rates in the database
        rates.each do |currency, rate|
          ExchangeRate.create(
            base_currency: base_currency,
            target_currency: currency,
            rate: rate,
            fetched_at: Time.at(timestamp)
          )
        end
      else
        Rails.logger.error("Failed to fetch exchange rates: #{data['error']}")
      end
    else
      Rails.logger.error("HTTP request failed with status: #{response.status}")
    end
  end
end
