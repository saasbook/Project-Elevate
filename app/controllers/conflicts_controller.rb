class ConflictsController < ApplicationController
    def index
        @calendars = Calendar.all.where(:conflict => "Conflict")
    end
end
