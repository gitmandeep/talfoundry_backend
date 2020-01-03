# PayPal::SDK.configure(
#   mode: ENV['PAYPAL_ENV'],
#   client_id: ENV['PAYPAL_CLIENT_ID'],
#   client_secret: ENV['PAYPAL_CLIENT_SECRET'],
# )
require 'paypal-sdk-rest'
include PayPal::SDK::OpenIDConnect
PayPal::SDK.configure({
	:openid_client_id     => ENV['PAYPAL_CLIENT_ID'],
	:openid_client_secret => ENV['PAYPAL_CLIENT_SECRET'],
	:openid_redirect_uri  => ENV['PAYPAL_REDIRECT_URI']
})
PayPal::SDK.logger.level = Logger::INFO
