class HomeController < ApplicationController

    # def user_params
        
    # end

    def index
        # redirect_to '/users/sign_in'
        if current_user #check if user is signed in
            if current_user.membership == "Club Member"
                @calendars = Calendar.all.where(:UserId => [current_user.id, nil]).order(:start_time)
            elsif current_user.membership == "Coach"
                @calendars = Calendar.all.where(:UserId => [current_user.id, nil]) #only booked classes currently
            else
                @calendars = Calendar.all
            #add admin
            end
            @calendarsShow = @calendars.limit(5)
            @todayEvents = @calendars.all.where("start_time < ?", Time.now.end_of_day).where( "start_time > ?", Time.now.beginning_of_day).count
        end
    end
        

   

end
