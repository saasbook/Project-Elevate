Feature: View Calendar list and buttons

  As an user of this app
  So that I can see and edit my events
  I want to see my calendar and the list of events

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    | confirmed_at             |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   | 2013-02-02 01:00:00 UTC  |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator | 2013-02-02 01:00:00 UTC  |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC  |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       | 2013-02-02 01:00:00 UTC  |
  | Jason Yang      | jason@gmail.com          | 123456   | Club Member   | 2013-02-02 01:00:00 UTC  |

 Given the following calendars exist:
  | name                       | UserId  | OtherId | start_time          | end_time            |
  | Train with Roger Destroyer | 1       | 2       | 2020-04-05 10:00:00 | 2020-04-05 12:00:00 |
  | Coach Joe Chen             | 2       | 1       | 2020-04-05 10:00:00 | 2020-04-05 10:00:00 |
  | Club Event                 | nil     | nil     | 2020-04-11 10:00:00 | 2020-04-11 12:00:00 |
  | Club Event                 | nil     | nil     | 2020-04-05 10:00:00 | 2020-04-05 12:00:00 |
  | Club Event                 | nil     | nil     | 2020-04-13 10:00:00 | 2020-04-13 12:00:00 |
  | Club Event                 | nil     | nil     | 2020-04-14 10:00:00 | 2020-04-14 12:00:00 |
  | Club Event                 | nil     | nil     | 2020-04-21 10:00:00 | 2020-04-21 12:00:00 |
  | Play with Joe Chen         | 5       | 1       | 2020-04-28 10:00:00 | 2020-04-28 12:00:00 |
  | Play with Jason Yang       | 1       | 5       | 2020-04-28 10:00:00 | 2020-04-28 12:00:00 |
  | Coach Jason Yang           | 2       | 5       | 2020-04-14 10:00:00 | 2020-04-14 12:00:00 |
  | Train with Roger Destroyer | 5       | 2       | 2020-04-14 10:00:00 | 2020-04-14 12:00:00 |

And I go to Login page


# Note that I need to specify passwords here because the authentication process won't let me access user password
Scenario: Log in as Jason Yang a Club Member with multiple events scheduled
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  And he should see the following: "Hi Jason Yang, You have 0 activities today!"
  And he should see the following: "More..., Manage my Calendar"
  And "Jason Yang" should see all the first five events he is a part of
  When he follows "More..."
  Then "Jason Yang" should see all the events he is a part of
  And he should see the following: "Back to Profile, View Calendar"

Scenario: Log in as Jason Yang a Club Member to see his Calendar
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  When he follows "Manage my Calendar"
  Then "Jason Yang" should see the events he is a part of for this month
  And he should see the following: "Back to Profile"

Scenario: Log in as Jason Yang a Club member and wants to view the details of the first event shown on the profile page
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  Then he should see "Details"
  When he follows the "1" "Details"
  And he should see the following: "Name, Start time, End time, View Calendar, Back to Profile"

Scenario: Log in as Roger Destroyer a Coach with multiple events scheduled
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  And he should see the following: "Hi Roger Destroyer, You have 0 activities today!"
  And he should see the following: "More..., Manage my Calendar"
  And "Roger Destroyer" should see all the first five events he is a part of
  When he follows "More..."
  Then "Roger Destroyer" should see all the events he is a part of
  And he should see the following: "Back to Profile, View Calendar"

Scenario: Log in as Roger Destroyer a Coach to see his Calendar
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  When he follows "Manage my Calendar"
  Then "Roger Destroyer" should see the events he is a part of for this month
  And he should see the following: "Back to Profile"

# Scenario: Log in as Roger Destroyer a Coach and wants to view the details of the first event shown on the profile page
#   Given "Roger Destroyer" is a "Coach"
#   And "Roger Destroyer" logs in with correct credentials with password "12345678"
#   Then he should see "Details"
#   When he follows the "1" "Details"
#   And he should see the following: "Name, Start time, End time, Edit, View Calendar, Back to Profile"

Scenario: Log in as Matthew Sie, an Admin to go to List of events
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  And he should see the following: "Hi Matthew Sie, You have 0 activities today!"
  And he should see the following: "More..., Manage my Calendar"
  And he should see the first five events
  When he follows "More..."
  Then he should see all the events
  And he should see the following: "Back to Profile, View Calendar"

Scenario: Log in as Matthew Sie, an Admin to see his Calendar
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  When he follows "Manage my Calendar"
  Then he should see the events for this month
  And he should see the following: "Back to Profile"

Scenario: Log in as Matthew Sie a Administrator and wants to view the details of the first event shown on the profile page
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  Then he should see "Details"
  When he follows the "1" "Details"
  And he should see the following: "Name, Start time, End time, View Calendar, Back to Profile"
