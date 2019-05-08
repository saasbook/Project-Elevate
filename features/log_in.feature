Feature: Log in to different types of accounts
 
  As an user of this app
  So that I can confirm my account
  I want to see which account I am in

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    | confirmed_at             |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   | 2013-02-02 01:00:00 UTC  |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator | 2013-02-02 01:00:00 UTC  |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC  |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       | 2013-02-02 01:00:00 UTC  |
And I go to Login page


# Note that I need to specify passwords here because the authentication process won't let me access user password 
Scenario: log in as a Manager
  Given "John Doe" is a "Manager"
  And "John Doe" logs in with correct credentials with password "12345678"
  Then "John Doe" goes to "My Profile Page" 
  And he should see membership as "John Doe | Manager"

Scenario: log in as a Club Member
  Given "Joe Chen" is a "Club Member"
  And "Joe Chen" logs in with correct credentials with password "88888888"
  Then "Joe Chen" goes to "My Profile Page" 
  And he should see membership as "Membership: Club Member"

Scenario: log in as a Coach
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  Then "Roger Destroyer" goes to "My Profile Page" 
  And he should see membership as "Membership: Coach"
 
Scenario: log in as an Administrator
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  Then "Matthew Sie" goes to "My Profile Page" 
  And he should see membership as "Matthew Sie | Administrator"
  
  