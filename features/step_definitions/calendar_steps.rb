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

Then /he should see all the events/ do
  Calendar.all.where("start_time > ?", Time.now.beginning_of_day).order(:start_time).each do |calendar|
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

Then /"(.*)" should see every member and coach except himself/ do |name|
  user = User.find_by_name(name)
  User.all.where.not(:id => user.id).each do |users|
    step %{I should see "#{users.name}"}
  end
  step %{I should not see "#{user.name}"}
end 

When /he goes to "(.*)" calendar/ do |name|

  find(:id => name + "calendar").click
end 

When /he goes to "(.*)" event list/ do |name|

  find(:id => name + "list").click
end 


Then /he should be able to see "(.*)" events for this month/ do |name|
  user = User.find_by_name(name)
  Calendar.all.where(:userId => [user.id, nil]).each do |calendar|
      if (calendar.start_time.month == Time.now.month and calendar.start_time.year == Time.now.year)
        step %{I should see "#{calendar.name}"}
      end
    end
end

Then /he should be able to see all of "(.*)" events/ do |name|
  user = User.find_by_name(name)
  Calendar.all.where(:UserId => [user.id, nil]).where("start_time > ?", Time.now.beginning_of_day).order(:start_time).each do |calendar|
      if (calendar.start_time.month == Time.now.month and calendar.start_time.year == Time.now.year)
        step %{I should see "#{calendar.name}"}
      end
    end
end

And /he visits "(.*)"/ do |url|
  visit (url)
end


When /I submit the form and press "(.*)"/ do |button|
  click_button(button)
end

Then /I hit the alert button/ do
  page.accept_confirm { click_button "OK" }
end
When("I grant ok") do
  begin
    main, popup = page.driver.browser.window_handles
    within_window(popup) do
      click_on("OK")
    end
  rescue
  end
end