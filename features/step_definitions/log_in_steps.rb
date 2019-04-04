
Given /the following users exist/ do |users_table|
    users_table.hashes.each do |user|
      User.create user
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
