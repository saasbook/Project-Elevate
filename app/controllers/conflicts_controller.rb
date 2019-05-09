class ConflictsController < ApplicationController
    def index
        @calendar = Calendar.all.where(:conflict => "Conflict")
        if @calendar.empty?
            render 'no_conflicts'
        end
    end
end
