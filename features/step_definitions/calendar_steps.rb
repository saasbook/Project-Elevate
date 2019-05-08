Then /"(.*)" should see all the events he is a part of/ do |name|
  user = User.find_by_name(name)
  Calendar.all.where(:UserId => [user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time).each do |calendar|
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

<<<<<<< HEAD
Then /he should see all the events/ do 
  Calendar.all.where(:UserId => nil).where("start_time > ?", Time.now.beginning_of_day).order(:start_time).each do |calendar|
=======
Then /he should see all the events/ do
  Calendar.all.where("start_time > ?", Time.now.beginning_of_day).order(:start_time).each do |calendar|
>>>>>>> 64c7c8c5ff6f0434324cc37393be7bcf6e81f24b
        step %{I should see "#{calendar.name}"}
  end
end

<<<<<<< HEAD
Then /he should see the events for this month/ do 
  Calendar.all.where(:UserId => nil).each do |calendar|
=======
Then /he should see the events for this month/ do
  Calendar.all.each do |calendar|
>>>>>>> 64c7c8c5ff6f0434324cc37393be7bcf6e81f24b
      if (calendar.start_time.month == Time.now.month and calendar.start_time.year == Time.now.year)
        step %{I should see "#{calendar.name}"}
      end
    end
end

And /"(.*)" should see all the first five events he is a part of/ do |name|
    user = User.find_by_name(name)
    Calendar.all.where(:UserId => [user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

And /"(.*)" should see the first five events/ do |name|
    Calendar.all.where(:userId => nil).order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

And /he should see the first five events/ do
    Calendar.all.where(:UserId => nil).where("start_time > ?", Time.now.beginning_of_day).order(:start_time).limit(5).each do |calendar|
        step %{I should see "#{calendar.name}"}
    end
end

When("he follows the {string} {string}") do |string, string2|
    first(:link, "Details").click
  # pending # Write code here that turns the phrase above into concrete actions
end
