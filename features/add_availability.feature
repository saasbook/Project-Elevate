Feature: Add availability as a coach
 
  As an coach using this app
  So that I can coach club members
  I want add availabilities

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    | confirmed_at |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC |
And the following availabilities exist:
  | coach_id     | day      | start_time    | end_time  |
  | 6            | Sunday   | 9am           | 12pm      |
  | 6            | Sunday   | 12pm          | 3pm       |
  | 6            | Sunday   | 3pm           | 6pm       |


Scenario: Add availibility with no issues
  Given "Pizza" is a "Coach"
  And "Pizza" logs in with correct credentials with password "12345678"
  And "Pizza" goes to "Availabilities Page"
  Then I select "Sunday" from "user_day"
  And I select "9" from "user_start_time"
  And I select "00" from "user_start_time_s"
  And I select "AM" from "user_start_time_ampm"
  And I select "12" from "user_end_time"
  And I select "00" from "user_end_time_s"
  And I select "PM" from "user_end_time_ampm"
  And I press "Add availibility"
  Then I should see "9:00AM - 12:00PM"

Scenario: Add availibility but incorrect availibilty
  Given "Pizza" is a "Coach"
  And "Pizza" logs in with correct credentials with password "12345678"
  And "Pizza" goes to "Availabilities Page"
  Then I select "Sunday" from "user_day"
  And I select "7" from "user_start_time"
  And I select "00" from "user_end_time_s"
  And I select "AM" from "user_end_time_ampm"
  And I select "12" from "user_end_time"
  And I select "00" from "user_end_time_s"
  And I select "PM" from "user_end_time_ampm"
  And I press "Add availibility"
  Then I should not see "7:00AM - 12:00PM"
  And I should see "Invalid Time"

Scenario: Add availibility with no issues with 30 minute blocks
  Given "Pizza" is a "Coach"
  And "Pizza" logs in with correct credentials with password "12345678"
  And "Pizza" goes to "Availabilities Page"
  Then I select "Sunday" from "user_day"
  And I select "7" from "user_start_time"
  And I select "00" from "user_start_time_s"
  And I select "AM" from "user_start_time_ampm"
  And I select "12" from "user_end_time"
  And I select "30" from "user_end_time_s"
  And I select "PM" from "user_end_time_ampm"
  And I press "Add availibility"
  Then I should not see "7:00AM - 12:30PM"
  And I should see "Invalid Time"