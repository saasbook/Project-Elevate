class Booking < ApplicationRecord
    def self.check_time_slot(start_slot, end_slot, id, month, day)
      date_start_slot = DateTime.new(DateTime.now.year.to_i, month.to_i, day.to_i, start_slot.hour, start_slot.min, 0, '-7')
      date_end_slot = DateTime.new(DateTime.now.year.to_i, month.to_i, day.to_i, end_slot.hour, end_slot.min, 0, '-7')

      Calendar.where(OtherId: id, event_month: month, event_day: day).each do |record|
        if (date_start_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds) || date_end_slot.between?(record.start_time + 1.seconds, record.end_time - 1.seconds))
          return false
        elsif ((date_start_slot == record.start_time) && (date_end_slot == record.end_time))
          return false
        end
      end

      return true
    end
end
