class Booking < ApplicationRecord

    # This method checks if there is a time conflict between any of the events in the Calendar table and the created event (passed in the parameter)
    def self.check_time_slot(start_slot, end_slot, id, month_day_year)
      date_start_slot = DateTime.new(month_day_year[2].to_i, month_day_year[0].to_i, month_day_year[1].to_i, start_slot.hour, start_slot.min, 0, "-07:00")
      date_end_slot = DateTime.new(month_day_year[2].to_i, month_day_year[0].to_i, month_day_year[1].to_i, end_slot.hour, end_slot.min, 0, "-07:00")

      Calendar.where(OtherId: id, event_month: month_day_year[0].to_s, event_day: month_day_year[1].to_s).each do |record|
        if (date_start_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds) || date_end_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds))
          return false
        elsif ((date_start_slot == record.start_time) && (date_end_slot == record.end_time))
          return false
        end
      end

      return true
    end
end
