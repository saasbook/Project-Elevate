Rails.configuration.stripe = {
  :publishable_key => 'pk_test_VvM04hFfvQ7zNg4rYmeeZrou00PTrN55ts',
  :secret_key      => 'sk_test_dmGMNsDfeaNwiHx2Mnj5iYuj00nTho4PyL'

}

Stripe.api_key = Rails.configuration.stripe[:secret_key]