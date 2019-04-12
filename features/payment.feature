Feature: Purchase Credits as a Club Member
 
    As a club member
    I want to purchase credits
    So that I can use them to buy lessons

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
Scenario: Buys 2 group lesson credits
  Given "Joe Chen" logs in with correct password "88888888" and goes to profile page
  And I go to Buy Credits page
  And I select "2" from "user_group_num_credit"
  Then I press "Proceed to Checkout"
  Then I should see "Number of Group Lesson Credits in Cart:"
  
  
  
  