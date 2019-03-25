class HomeController < ApplicationController

    # def user_params
        
    # end

    def index
        # redirect_to '/users/sign_in'
    end

    def member_profile
        if current_user.membership == 'Club Member'
            @membership = 'Club Member'
            # Add everything else needed here
        elsif current_user.membership == 'Administrator'
            @membership = 'Administrator'
            # Add everything else needed here
        elsif current_user.membership == 'Coah'
            @membership = 'Coach'
            # Add everything else needed here
        elsif current_user.membership == 'Manager'
            @membership = 'Manager'
            # Add everything else needed here
        end
    
    end


end
