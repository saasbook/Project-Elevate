class ConflictsController < ApplicationController
    def index
        @calendars = Calendar.all.where(:conflict => "Conflict")
        if @calendars.empty?
            render 'no_conflicts'
        end
    end
end
