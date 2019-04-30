Feature: Update single payment pacakge as a admin

    As a Admin
    I want update the single package
    So that I can change prices

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         |
Given the following payment_packages exist:
    |id  | name  |   num_classes |   price   |
    | 5  | Single  |   1          |   10      |
And "Pizza" logs in with correct credentials with password "12355678"
And I go to Payment Packages Page


Scenario: Cannot delete package
    Then I should not see "delete_5" 