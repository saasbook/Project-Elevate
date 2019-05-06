class MembershipHistoryController < ApplicationController
    def membership_history
        if current_user.membership == "Administrator"
          @histories = MembershipHistory.order(created_at: :desc)
        else
          redirect_to '/user/profile'
        end
    end
end
