class MembershipHistoryController < ApplicationController
    def membership_history
      @name = current_user.name
      @membership = current_user.membership
        if current_user.membership == "Administrator"
          @histories = MembershipHistory.order(created_at: :desc)
        else
          redirect_to membership_status_path
        end
    end
end
