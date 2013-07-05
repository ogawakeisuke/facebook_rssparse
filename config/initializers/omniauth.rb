# require 'omniauth/oauth'

# app_id = '458325234245817'
# app_secret = '64757242b2bdd251e1303ea5e0346324'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook , FB_APP_ID , FB_APP_SECRET  , { :scope => 'publish_actions, offline_access,  photo_upload' }
end