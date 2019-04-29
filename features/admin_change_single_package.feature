Feature: Update payment pacakge as a admin
 
    As a Admin
    I want update package credits
    So that I can offer discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         |
Given the following payment_packages exist:
    |id  | name  |   num_classes |   price   |
    | 4  | Single  |   1          |   10      |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page


Scenario: Cannot delete package
    Then I should not see "delete_1"
    When I follow "edit_4"
  Then I should not see "payment_package_name"
  And I should not see "payment_package_num_classes"