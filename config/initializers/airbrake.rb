Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.params_filters << 'auth_token'
end
