require 'capybara'

And /I fill in email, card number, expiration date, and csv/ do
    step %{I fill in "Email" with "chenjoe@gmail.com"}
end


Then /I press Pay with Card/ do
    sess = Capybara::Session.new(:selenium)
    sess.visit("https://stripe.com/docs/checkout")
    sess.click_button('Pay with Card')
    # click_on(class: 'stripe-button-el')
    # find("button.stripe-button").click
end