Feature: View Calendar list and buttons

  As an user of this app
  So that I can see my 5 next events
  I want to see my calendar and all th events

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       |
  | Jason Yang      | jason@gmail.com          | 123456   | Club Member   |

 Given the following calendars exist:
  | name                       | UserId  | OtherId | start_time          | end_time            |
  | Train with Roger Destroyer | 1       | 2       | 2019-04-05 10:00:00 | 2019-04-05 12:00:00 |
  | Coach Joe Chen             | 2       | 1       | 2019-04-05 10:00:00 | 2019-04-05 10:00:00 |
  | Club Event                 | nil     | nil     | 2019-04-11 10:00:00 | 2019-04-11 12:00:00 |
  | Club Event                 | nil     | nil     | 2019-04-05 10:00:00 | 2019-04-05 12:00:00 |
  | Club Event                 | nil     | nil     | 2019-04-13 10:00:00 | 2019-04-13 12:00:00 |
  | Club Event                 | nil     | nil     | 2019-04-14 10:00:00 | 2019-04-14 12:00:00 |
  | Club Event                 | nil     | nil     | 2019-04-21 10:00:00 | 2019-04-21 12:00:00 |
  | Play with Joe Chen         | 5       | 1       | 2019-04-28 10:00:00 | 2019-04-28 12:00:00 |
  | Play with Jason Yang       | 1       | 5       | 2019-04-28 10:00:00 | 2019-04-28 12:00:00 |
  | Coach Jason Yang           | 2       | 5       | 2019-04-14 10:00:00 | 2019-04-14 12:00:00 |
  | Train with Roger Destroyer | 5       | 2       | 2019-04-14 10:00:00 | 2019-04-14 12:00:00 |

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
  And he should see the following: "Back to Profile"

Scenario: Log in as Jason Yang a Club Member to see his Calendar
  Given "Jason Yang" is a "Club Member"
  And "Jason Yang" logs in with correct credentials with password "123456"
  When he follows "Manage my Calendar"
  Then "Jason Yang" should see the events he is a part of for this month
  And he should see the following: "Back to Profile"

Scenario: Log in as Roger Destroyer a Coach with multiple events scheduled
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  And he should see the following: "Hi Roger Destroyer, You have 0 activities today!"
  And he should see the following: "More..., Manage my Calendar"
  And "Roger Destroyer" should see all the first five events he is a part of
  When he follows "More..."
  Then "Roger Destroyer" should see all the events he is a part of
  And he should see the following: "Back to Profile"

Scenario: Log in as Roger Destroyer a Coach to see his Calendar
  Given "Roger Destroyer" is a "Coach"
  And "Roger Destroyer" logs in with correct credentials with password "12345678"
  When he follows "Manage my Calendar"
  Then "Roger Destroyer" should see the events he is a part of for this month
  And he should see the following: "Back to Profile"
  
Scenario: Log in as Matthew Sie, an Admin
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  And he should see the following: "Hi Matthew Sie, You have 0 activities today!"
  And he should see the following: "More..., Manage my Calendar"
  And he should see the first five events
  When he follows "More..."
  Then he should see all the events
  And he should see the following: "Back to Profile"

Scenario: Log in as Matthew Sie, an Admin
  Given "Matthew Sie" is a "Administrator"
  And "Matthew Sie" logs in with correct credentials with password "dabaka22"
  When he follows "Manage my Calendar"
  Then he should see the events for this month
  And he should see the following: "Back to Profile"
