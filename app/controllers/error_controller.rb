class ErrorController < ApplicationController
  # Can show error, but right now it just redirects to the home page 
  def error_404
    redirect_to :controller => "home", :action => "index" 
    # @requested_path = request.path  #This is needed if using the error_404 html page
  end
end
