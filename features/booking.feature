Feature: Book a lesson as a member

  As a member using this app
  So that I can find a coach to learn from
  I want to book lessons

Background: Users in the Database
 Given the following users exist:
  | id  | name            | email                    | password | membership    | confirmed_at |
  | 1   | Kenneth Ahne    | kenneth@gmail.com        | 123456   | Club Member   | 2013-02-02 01:00:00 UTC |
  | 2   | Jason Yang      | jason@gmail.com          | 123456   | Club Member   | 2013-02-02 01:00:00 UTC |
  | 3   | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC |
And the following availabilities exist:
  | coach_id     | day      | start_time    | end_time  |
  | 3            | Sunday   | 1pm           | 3pm       |
  | 3            | Sunday   | 4pm           | 7pm       |

Scenario: Display availabilities
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  And "Jason Yang" goes to "Booking Page"
  When I select "Roger Destroyer" from "user_coach"
  And I select "April" from "user_month"
  And I select "28" from "user_day"
  And I press "View availabilities"
  Then I should see "1:00PM - 2:00PM"
  And I should see "1:30PM - 2:30PM"
  And I should see "2:00PM - 3:00PM"
  And I should see "4:00PM - 5:00PM"
  And I should see "6:00PM - 7:00PM"

Scenario: Successfully book a lesson
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  And "Jason Yang" goes to "Booking Page"
  Then I select "Roger Destroyer" from "user_coach"
  And I select "April" from "user_month"
  And I select "28" from "user_day"
  And I press "View availabilities"
  When I choose the time slot "1:00PM - 2:00PM"
  And I press "Next"
  Then I should see "Thank you for booking a lesson!"

Scenario: Fail to select an availability
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  And "Jason Yang" goes to "Booking Page"
  And I press "View availabilities"
  And I press "Next"
  Then I should see "Please choose a time slot."
