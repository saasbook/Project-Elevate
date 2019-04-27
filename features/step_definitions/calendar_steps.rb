Then /"(.*)" should see all the events he is a part of/ do |name|
  user = User.find_by_name(name)
  Calendar.all.where(:UserId => [user.id, nil]).order(:start_time).each do |calendar|
      step %{I should see "#{calendar.name}"}
  end
end

Then /"(.*)" should see the events he is a part of for this month/ do |name|
  user = User.find_by_name(name)
  Calendar.all.where(:UserId => [user.id, nil]).each do |calendar|
      if (calendar.start_time.month == Time.now.month and calendar.start_time.year == Time.now.year)
        step %{I should see "#{calendar.name}"}
      end
  end
end

Then /he should see all the events/ do 
  Calendar.all.order(:start_time).each do |calendar|
        step %{I should see "#{calendar.name}"}
  end
end

Then /he should see the events for this month/ do 
  Calendar.all.each do |calendar|
      if (calendar.start_time.month == Time.now.month and calendar.start_time.year == Time.now.year)
        step %{I should see "#{calendar.name}"}
      end
    end
end

And /"(.*)" should see all the first five events he is a part of/ do |name|
    user = User.find_by_name(name)
    Calendar.all.where(:UserId => [user.id, nil]).order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

And /"(.*)" should see the first five events/ do |name|
    Calendar.all.order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

And /he should see the first five events/ do
    Calendar.all.order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

