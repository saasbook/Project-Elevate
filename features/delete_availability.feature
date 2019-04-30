Feature: Delete availability as a coach

  As an coach using this app
  So that I can coach club members
  I want delete availabilities

Background: Users in the Database
 Given the following users exist:
  | id   | name            | email                 | password | membership    | confirmed_at |
  | 200  | Pizza           | pizza@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC |

And the following availabilities exist:
  | id  | coach_id     | day      | start_time    | end_time  |
  | 101 | 200          | Sunday   | 9am           | 12pm      |
  | 102 | 200          | Monday   | 12pm          | 3pm       |
  | 103 | 200          | Sunday   | 12pm          | 3pm       |
  | 104 | 200          | Sunday   | 3pm           | 6pm       |


Scenario: Delete availibility
  Given "Pizza" is a "Coach"
  And "Pizza" logs in with correct credentials with password "12345678"
  And "Pizza" goes to "Availabilities Page"
  Then I should see "9:00AM - 12:00PM"
  And I click "101_delete"
  Then I should not see "9:00AM - 12:00PM"
  But I should see "12:00PM - 3:00PM"

Scenario: Delete availibility with a day that has the same time
  Given "Pizza" is a "Coach"
  And "Pizza" logs in with correct credentials with password "12345678"
  And "Pizza" goes to "Availabilities Page"
  Then I should see "12:00PM - 3:00PM"
  And I click "102_delete"
  Then I should see "12:00PM - 3:00PM"
  And I click "103_delete"
  But I should not see "12:00PM - 3:00PM"
