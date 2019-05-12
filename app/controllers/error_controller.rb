class ErrorController < ApplicationController
  def error_404
    @requested_path = request.path
  end
end
