class MembershipHistoryController < ApplicationController
    def membership_history
        if current_user.membership == "Administrator"
          @histories = MembershipHistory.all
        else
          redirect_to '/user/profile'
        end
    end
end
