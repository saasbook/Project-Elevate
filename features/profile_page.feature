Feature: View Profile Pages 
 
  As an user of this app
  So that I can view my profile page contents
  I want to visit my profile page and see appropriate contents

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
  And he should see the following: "Joe Chen, Roger Destroyer"
  And he should not see "Matthew Sie"


# Note that I need to specify passwords here because the authentication process won't let me access user password 
Scenario: log in as a Manager
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  Then "Matthew Sie" goes to "My Profile Page" 
  And he should see the following: "Joe Chen, Roger Destroyer, John Doe"
  
