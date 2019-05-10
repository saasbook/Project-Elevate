class Booking < ApplicationRecord
    def self.check_time_slot(start_slot, end_slot, id, month_day, year_index)
      date_start_slot = DateTime.new(year_index, month_day[0].to_i, month_day[1].to_i, start_slot.hour, start_slot.min, 0, "-07:00")
      date_end_slot = DateTime.new(year_index, month_day[0].to_i, month_day[1].to_i, end_slot.hour, end_slot.min, 0, "-07:00")

      Calendar.where(OtherId: id, event_month: month_day[0].to_s, event_day: month_day[1].to_s).each do |record|
        if (date_start_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds) || date_end_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds))
          return false
        elsif ((date_start_slot == record.start_time) && (date_end_slot == record.end_time))
          return false
        end
      end

      return true
    end
end
