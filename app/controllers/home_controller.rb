class HomeController < ApplicationController
    before_action :authenticate_user!

    # def user_params

    # end

    def index
        # redirect_to '/users/sign_in'
<<<<<<< HEAD
    
        @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
        @calendarsShow = @calendars.limit(5)
=======

        if current_user.membership == "Club Member" or current_user.membership == "Coach"
            @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
        else
            @calendars = Calendar.all.where("start_time > ?", Time.now.beginning_of_day).order(:start_time)
        #add admin
        end
         @calendarsShow = @calendars.limit(5)
>>>>>>> 64c7c8c5ff6f0434324cc37393be7bcf6e81f24b
        @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count


    end

    def home
    end




end
