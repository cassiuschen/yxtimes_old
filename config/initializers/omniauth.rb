Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bdfzer, CONFIG['bdfzer_app_id'], CONFIG['bdfzer_app_sec']
end
