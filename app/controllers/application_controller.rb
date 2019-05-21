class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :user_tag

  def user_tag
      if user_signed_in?
        @name = current_user.name
        @membership = current_user.membership
      end
  end

  protected

    def configure_permitted_parameters
      added_attr =  [:name, :membership, :my_admin]
      devise_parameter_sanitizer.permit(:sign_up, keys: added_attr)
      devise_parameter_sanitizer.permit(:account_update, keys: added_attr)
    end
end
