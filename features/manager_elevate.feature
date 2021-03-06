Feature: (D)elevate other users as Manager
 
    As a manager
    I want to see the correct membership statuses
    So that I can validly (d)elevate users to other membership statuses

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    | confirmed_at             |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   | 2013-02-02 01:00:00 UTC  |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator | 2013-02-02 01:00:00 UTC  |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC  |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       | 2013-02-02 01:00:00 UTC  |

And I go to Login page

# Note that I need to specify passwords here because the authentication process won't let me access user password 
# All scenarios begin assuming no user is logged in yet
Scenario: Update Membership as manager (elevate)
  Given "Matthew Sie" logs in with correct password "dabaka22" and goes to elevate page
  And selects status "Coach" for "Joe Chen"
  When I press "Joe Chen_update"
  Then he should see attribute "membership" value "Coach" for "Joe Chen"

Scenario: Update Membership as manager (delevate)
  Given "Matthew Sie" logs in with correct password "dabaka22" and goes to elevate page
  And selects status "Club Member" for "Roger Destroyer"
  When I press "Roger Destroyer_update"
  Then he should see attribute "membership" value "Club Member" for "Roger Destroyer"
