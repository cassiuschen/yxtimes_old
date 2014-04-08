Rails.application.config.middleware.use OmniAuth::Builder do
  APP_ID = "ab5bd555d4537f02c280158ff01a5f2c8f8f42e3dc8c976f4983abd4af3d9d63"
  APP_SEC = "aa177ee5ab83ff7778b076c0cc5a9f61fee78b896c945d67033994281fba867f"
  provider :bdfzer, APP_ID, APP_SEC
end
