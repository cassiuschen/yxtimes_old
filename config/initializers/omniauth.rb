Rails.application.config.middleware.use OmniAuth::Builder do
  APP_ID = "6d325b84369766cddab1e5a2ae3c8e2c4d434af7d6cbe7cc80eaa8e5e0bfa755"
  APP_SEC = "64bd6f60aa073e64205274ee28b89319b8f36811fe72977325aa488991cc8428"
  provider :bdfzer, APP_ID, APP_SEC
end
