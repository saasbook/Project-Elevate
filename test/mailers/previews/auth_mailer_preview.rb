class MyMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    @a = User.first
    @a.unconfirmed_email = 'a@email.com'
    AuthMailer.confirmation_instructions(@a, "faketoken", {})
  end

#   def reset_password_instructions
#     MyMailer.reset_password_instructions(User.first, "faketoken", {})
#   end

#   def unlock_instructions
#     MyMailer.unlock_instructions(User.first, "faketoken", {})
#   end
end