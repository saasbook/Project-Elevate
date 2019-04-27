Given /the following availabilities exist/ do |avail_table|
    avail_table.hashes.each do |avail|
      CoachAvailability.create avail
    end
  end


And /"I go to "(.*)"/ do |page_name|
    step %{I go to #{page_name}}
end