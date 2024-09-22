set :environment, "development" # or 'production' if in production
# set :environment, "production" # or 'development' if in development
set :output, "log/cron_log.log"

every 1.day, at: "12:00 am" do
  runner "DailyExchangeRateStorageJob.perform_later"
end
