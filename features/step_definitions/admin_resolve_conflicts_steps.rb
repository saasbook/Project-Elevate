Given /"(.*)" logs in with correct password "(.*)" and goes to conflict page/ do |name, password|
    step %{I sign in with valid credentials with "#{name}" account with password: "#{password}"}
    step %{I go to conflict page}
end