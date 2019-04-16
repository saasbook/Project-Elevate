
Given /the following users exist/ do |users_table|
    users_table.hashes.each do |user|
      User.create user
    end
  end
  
Given /the following calendars exist/ do |calendars_table|
    calendars_table.hashes.each do |calendar|
      Calendar.create calendar
    end
  end


Given /"(.*)" is a "(.*)"/ do |name, membership|
    user = User.find_by_name(name)
    expect(membership).to eq(user.membership)
end

# I need password here because the authentication process won't let me access user password 
Given /"(.*)" logs in with correct credentials with password "(.*)"/ do |name, password|
    user = User.find_by_name(name)
    step %{I sign in with valid credentials with "#{name}" account with password: "#{password}"}
    
end
  

And /"(.*)" goes to "(.*)"/ do |name, page_name|
    step %{I go to #{name}'s #{page_name}}

end

Then /he should see membership as "(.*)"/ do |membership|
    step %{I should see "#{membership}"}
end

And /he should see "(.*)"/ do |page_name|
    step %{I should see "#{page_name}"}
end

And /he should not see "(.*)"/ do |page_name|
    step %{I should not see "#{page_name}"}
end

And /he should see the following: "(.*)"/ do |text_lists|
    text_lists.split(', ').each do |text|
        step %{I should see "#{text}"}
    end
end

And /he should not see the following: "(.*)"/ do |text_lists|
    text_lists.split(', ').each do |text|
        step %{I should not see "#{text}"}
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




# And /"(.*)" should not see any events he is not a part of/ do |name|
#     user = User.find_by_name(name)
#     Calendar.all.where.not(:UserId => [user.id, nil]).each do |calendar|
#         step %{I should not see "#{calendar.name}"}
#     end
# end

