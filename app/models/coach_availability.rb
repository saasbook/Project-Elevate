class CoachAvailability < ApplicationRecord
    def self.availibility
        ['6am','7am','8am','9am','10am','11am', '12pm', '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm']
    end

    def self.valid_availibility(id, day, start_time, end_time)
        new_st_hour = Time.parse(start_time).hour
        new_end_hour = Time.parse(end_time).hour
        other_avail = CoachAvailability.where(:coach_id => id, :day => day)

        valid = true

        if new_st_hour >= new_end_hour
            return false
        end

        other_avail.each do |a|
            if (new_st_hour...new_end_hour).overlaps?(a.start_time.hour...a.end_time.hour)
                valid = false
            end
        end

        return valid
    end
end
