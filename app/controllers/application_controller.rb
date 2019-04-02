class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attr = [:full_name, :membership]
    @users = User.all
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attr)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attr)
  end
  #   You want to get exceptions in development, but not in production.
  #   unless Rails.application.config.consider_all_requests_local
  #   rescue_from ActionController::RoutingError, with: -> { render_404  }
  #   rescue_from ActionController::UnknownController, with: -> { render_404  }
  #   rescue_from ActiveRecord::RecordNotFound,        with: -> { render_404  }
  # end

  # def render_404
  #   respond_to do |format|
  #     format.html { render template: 'error/error_404', status: 404 }
  #     format.all { render nothing: true, status: 404 }
  #   end
  # end


end
