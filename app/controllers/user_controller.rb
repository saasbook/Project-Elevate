class UserController < ApplicationController
  before_action :authenticate_user!

  def booking
    @coaches = User.coaches
    render "booking"
  end

end
