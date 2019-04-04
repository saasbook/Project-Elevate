Feature: Log in to different types of accounts
 
  As an user of this app
  So that I can confirm my account
  I want to see which account I am in

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       |
And I go to Login page


# Note that I need to specify passwords here because the authentication process won't let me access user password 
Scenario: log in as a Manager
  Given "John Doe" is a "Manager"
  And "John Doe" logs in with correct credentials with password "12345678"
  Then "John Doe" goes to "My Profile Page" 
  And he should see membership as "Manager"

Scenario: log in as a Club Member
  Given "Joe Chen" is a "Club Member"
  And "Joe Chen" logs in with correct credentials with password "88888888"
  Then "Joe Chen" goes to "My Profile Page" 
  And he should see membership as "Club Member"

Scenario: log in as a Coach
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  Then "Roger Destroyer" goes to "My Profile Page" 
  And he should see membership as "Coach"
 
Scenario: log in as an Administrator
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  Then "Matthew Sie" goes to "My Profile Page" 
  And he should see membership as "Administrator"
  
  