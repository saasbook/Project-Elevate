Feature: Add availability as a coach
 
  As an coach using this app
  So that I can coach club members
  I want add availabilities

Background: Users in the Database
 Given the following users exist:
  | name            | email                    | password | membership    |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       |
And the following availabilities exist:
  | coach_id     | day      | start_time    | end_time  |
  | 3            | Sunday   | 9am           | 12pm      |
  | 3            | Sunday   | 12pm          | 3pm       |
  | 3            | Sunday   | 3pm           | 6pm       |


Scenario: Add availibility with no issues
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  And I go to "Availabilities Page"
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
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  And I go to "Availabilities Page"
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
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  And I go to "Availabilities Page"
  Then I select "Sunday" from "user_day"
  And I select "9" from "user_start_time"
  And I select "00" from "user_start_time_s"
  And I select "AM" from "user_start_time_ampm"
  And I select "12" from "user_end_time"
  And I select "30" from "user_end_time_s"
  And I select "PM" from "user_end_time_ampm"
  And I press "Add availibility"
  Then I should not see "7:00AM - 12:30PM"
  And I should see "Invalid Time"