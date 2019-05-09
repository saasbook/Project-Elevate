class HomeController < ApplicationController
    before_action :authenticate_user!

    # def user_params

    # end

    def index
        # redirect_to '/users/sign_in'
    
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
        @calendarsShow = @calendars.limit(5)


        @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count


    end

    def home
    end




end
