class HomeController < ApplicationController

    # def user_params
        
    # end

    def index
        # redirect_to '/users/sign_in'
        
        if current_user.membership == "Club Member" or current_user.membership == "Coach"
            @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
        else
            @calendars = Calendar.all.order(:start_time)
        #add admin
        end
        @calendarsShow = @calendars.limit(5)
        @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count
        
    end
        

   

end
