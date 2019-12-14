Rails.configuration.stripe = {
  :publishable_key => Rails.application.credentials.publish_key_stripe || ENV['PUBLISHABLE_KEY'],
  :secret_key      =>  Rails.application.credentials.secret_key_stripe || ENV['SECRET_KEY']

}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
