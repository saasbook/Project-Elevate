Rails.configuration.stripe = {
#   :publishable_key => ENV['PUBLISHABLE_KEY'],
#   :secret_key      => ENV['SECRET_KEY']
  :publishable_key => "pk_test_gafSxFTLJ6IDFkHQPfzMa1Ym00RQDGkPJR",
  :secret_key      => "sk_test_9Zk6PGwl4v2HHET5pmnSzLE800VVOnQCkv"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]