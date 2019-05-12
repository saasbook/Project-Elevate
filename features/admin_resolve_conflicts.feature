Feature: Admin can resolve conflicts
 
    As an Admin
    I want to be able to see a log of conflicting bookings
    So that I can resolve conflicts by deleting one of the conflicting bookings

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    | confirmed_at             |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   | 2013-02-02 01:00:00 UTC  |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator | 2013-02-02 01:00:00 UTC  |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC  |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       | 2013-02-02 01:00:00 UTC  |

 And the following availabilities exist:
 | id  | coach_id     | day      | start_time    | end_time  |
 | 101 | 200          | Sunday   | 1pm           | 3pm       |
 | 102 | 200          | Sunday   | 4pm           | 7pm       |
 
Given the following payment_packages exist:
  |  name  |   num_classes |   price   |
  | Single |   1          |   10      |

Given the following calendars exist:
  | name                       | UserId  | OtherId | start_time          | end_time            | conflict |
  | Play with Jason Yang       | 2       | 1       | 2019-04-23 10:00:00 | 2019-04-23 12:00:00 | Conflict |

And I go to Login page

# Note that I need to specify passwords here because the authentication process won't let me access user password 
# All scenarios begin assuming no user is logged in yet
Scenario: See conflicts as admin
  Given "Matthew Sie" logs in with correct password "dabaka22" and goes to conflict page
  Then I should see "Play with Jason Yang"

Scenario: No conflict page link when not an admin
  Given "Joe Chen" logs in with correct credentials with password "88888888"
  Then I should not see "Resolve Booking Conflicts"

