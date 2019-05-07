Given /"(.*)" logs in with correct password "(.*)" and goes to elevate page/ do |name, password|
    step %{I sign in with valid credentials with "#{name}" account with password: "#{password}"}
    step %{I go to elevate Page}
end

And /selects status "(.*)" for "(.*)"/ do |status, name|
    select status, :from => "#{name}_user_membership"
end

Then /he should see attribute "(.*)" value "(.*)" for "(.*)"/ do |attribute, status, name|
    td = page.find(:css, 'td.name', text: name)
    tr = td.find(:xpath, './parent::tr')
    expect(tr).to have_css('td.' + attribute, text: status)
end
