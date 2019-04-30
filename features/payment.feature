Feature: Purchase Credits as a Club Member
 
    As a club member
    I want to purchase credits
    So that I can use them to buy lessons

Background: Users in the Database

 Given the following users exist:
  | name            | email                    | password | membership    | confirmed_at |
  | Joe Chen        | chenjoe@gmail.com        | 88888888 | Club Member   | 2013-02-02 01:00:00 UTC |
  | Matthew Sie     | matthew.sie@berkeley.edu | dabaka22 | Administrator | 2013-02-02 01:00:00 UTC |
  | Roger Destroyer | rogerahh@gmail.com       | 12345678 | Coach         | 2013-02-02 01:00:00 UTC |
  | John Doe        | johndoe@gmail.com        | 12345678 | Manager       | 2013-02-02 01:00:00 UTC |
Given the following payment_packages exist:
  |  name  |   num_classes |   price   |
  | Single  |   1          |   10      |

And I go to Login page

# Note that I need to specify passwords here because the authentication process won't let me access user password 
# All scenarios begin assuming no user is logged in yet
Scenario: Buys 2 group lesson credits
  Given "Joe Chen" logs in with correct password "88888888" and goes to profile page
  And I go to Buy Credits page
  Then I should be on Buy Credits page
  And I select "2" from "user_group_num_credit"
  Then I press "Proceed to Checkout"
  Then I should see "Number of Group Lesson Credits in Cart: 2"
  And I should see "Number of Assigned Private Lesson Credits in Cart: 0"
  And I should see "Number of Custom Private Lesson Credits in Cart: 0"

Scenario: I accidentially click proceed to checkout without selecting any lesson 
  Given "Joe Chen" logs in with correct password "88888888" and goes to profile page
  And I go to Buy Credits page
  And I select "0" from "user_group_num_credit"
  And I select "0" from "user_assigned_num_credit"
  And I select "0" from "user_custom_num_credit"
  Then I press "Proceed to Checkout"
  Then I should see "Please select some credit"
  
  



  
  
  
  