Feature: Admin can see all membership changes
 
    As an administrator
    I want to navigate to a change log
    So that I see all the membership status changes performed by other admins/managers

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       |

And I go to Login page

# Note that I need to specify passwords here because the authentication process won't let me access user password 
# All scenarios begin assuming no user is logged in yet
Scenario: See change log table as admin
  Given "Matthew Sie" logs in with correct password "dabaka22" and goes to profile page
  And I follow "User Membership Change Log"
  Then I should see "User Membership Change Log"

# Using the "admin_elevate_step" for "seeing" correct attributes in table
Scenario: Update user and see change in log table
  Given "Matthew Sie" logs in with correct password "dabaka22" and goes to profile page
  And selects status "Club Member" for "Roger Destroyer"
  When I press "Roger Destroyer_update"
  And I follow "User Membership Change Log"
