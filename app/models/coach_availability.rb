class CoachAvailability < ApplicationRecord
    def self.availibility
        1...13
    end

    def self.this_week(coach_id)
        res = Hash.new
        Date::DAYNAMES.each do |day|
            res[day] = CoachAvailability.where(:coach_id => coach_id, :day => day)
        end
        return res
    end

    def self.valid_availibility(id, day, st, et)
        new_st_time =  st.hour + sec_to_hour(st.sec)
        new_et_time = et.hour + sec_to_hour(et.sec)
        other_avail = CoachAvailability.where(:coach_id => id, :day => day)

        valid = true

        if new_st_time >= new_et_time
            return false
        end

        other_avail.each do |a|
            a_st_time = a.start_time.hour + sec_to_hour(a.start_time.sec)
            a_et_time = a.end_time.hour + sec_to_hour(a.end_time.sec)
            if (new_st_time...new_et_time).overlaps?(a.start_time.hour...a.end_time.hour)
                valid = false
            end
        end

        return valid
    end

    def self.sec_to_hour(sec)
        if sec == 30
            return 0.5
        end

        if sec == 0
            return 0
        end
    end


    def self.valid_time_slots(day)
      return 0
    end

    def self.sorted_avail_for_coach(id)
        CoachAvailability.where(:coach_id => id)
    end
end
