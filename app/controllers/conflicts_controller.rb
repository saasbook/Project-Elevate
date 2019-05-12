class ConflictsController < ApplicationController
    before_action :require_admin_priv

    def require_admin_priv
        if current_user.membership != 'Administrator'
            redirect_to root_path
        end
    end
    
    def index
        @calendar = Calendar.all.where(:conflict => "Conflict")
        if @calendar.empty?
            render 'no_conflicts'
        end
    end
end
