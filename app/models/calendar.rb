class Calendar < ApplicationRecord
  def self.create_event(event_info, ids, event_name_type, conflict_switch)
    if (conflict_switch)
      return Calendar.new(:name => event_name_type[0], :UserId => ids[0], :OtherId => ids[1], :start_time => event_info[0], :end_time => event_info[1], :typeEvent => event_name_type[1], :event_month => event_info[2].to_s, :event_day => event_info[3].to_s, :conflict => event_name_type[2])
    else
      return Calendar.new(:name => event_name_type[0], :UserId => ids[0], :OtherId => ids[1], :start_time => event_info[0], :end_time => event_info[1], :typeEvent => event_name_type[1], :event_month => event_info[2].to_s, :event_day => event_info[3].to_s)
    end
  end
end
