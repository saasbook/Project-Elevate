Feature: Delete payment pacakge as a admin
 
    As a Admin
    I want delete package credits
    So that I can stop offering discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         |
Given the following payment_packages exist:
    |id  | name  |   num_classes |   price   |
    | 1  | Gold  |   10          |   10      |
    | 2  | Red   |   200         |   2000    |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page

Scenario: Delete package successfully
  And I follow "delete_1"
  Then I should be on Payment Packages Page
  Then I should see "Red"
  And I should not see "Gold"
  Then I follow "delete_2"
  Then I should not see "Red"