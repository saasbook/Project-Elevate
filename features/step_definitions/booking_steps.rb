When /I choose the time slot (.*)/ do |time_slot|

  start_half = time_slot.split('-')[0].gsub(/[^0-9a-z:]/i, '')
  start_hour = start_half.split(':')[0].to_i
  start_minute = start_half.split(':')[1].gsub(/[^0-9]/i, '')
  if (time_slot.split('-')[0].gsub(/[^a-z]/i, '') == "PM")
    start_hour += 12
  end

  start_time_id = "user_temp_availability_2000-01-01_" + start_hour.to_s + start_minute + "00_-0800"

  end_half = time_slot.split('-')[1].gsub(/[^0-9a-z:]/i, '')
  end_hour = end_half.split(':')[0].to_i
  end_minute = end_half.split(':')[1].gsub(/[^0-9]/i, '')
  if (time_slot.split('-')[1].gsub(/[^a-z]/i, '') == "PM")
    end_hour += 12
  end

  end_time_id = "2000-01-01_" + end_hour.to_s + end_minute + "00_-0800"

  find_by_id(start_time_id + end_time_id).click
end
