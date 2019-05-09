class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  def index
      @admin = false
      if current_user.membership == "Club Member"
          @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).where.not(:typeEvent => [nil, ""]).order(:start_time)
      elsif current_user.membership == "Coach"
          @calendars = Calendar.all.where(:UserId => [current_user.id, nil]) #only booked classes currently
      #add admin

      else
        @calendars = Calendar.all
        @admin = true
      end
  end



  # GET /calendars/1
  def show
    if !@calendar.UserId.nil? and !@calendar.OtherId.nil?
      if current_user.membership == 'Club Member'
        @student = User.find(@calendar.UserId).name
        @instructor = User.find(@calendar.OtherId).name
      else
        @instructor = User.find(@calendar.UserId).name
        @student = User.find(@calendar.OtherId).name
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end
end
