class AuthMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  default from: 'projectElevateDev@gmail.com'
  layout 'mailer'
  
  def confirmation_instructions(record, token, opts={})
    # Use different e-mail templates for signup e-mail confirmation and for when a user changes e-mail address.
    if record.pending_reconfirmation?
      devise_mail(record, :email_changed, opts)
    else
      devise_mail(record, :confirmation_instructions, opts)
    end
  end
  
end
