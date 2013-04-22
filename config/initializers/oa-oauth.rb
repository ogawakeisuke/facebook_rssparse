require 'omniauth/oauth'

app_id = '458325234245817'
app_secret = '64757242b2bdd251e1303ea5e0346324'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook , app_id , app_secret # , { :scope => 'email, status_update, publish_stream' }
end