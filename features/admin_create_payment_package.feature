Feature: Add payment pacakge as a admin
 
    As a Admin
    I want create package credits
    So that I can offer discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page

Scenario: Add package successfully
  When I fill in "payment_package_name" with "Platinum"
  And I fill in "payment_package_num_classes" with "10"
  And I fill in "payment_package_price" with "200"
  And I press "Add package"
  Then I should be on Payment Packages Page
  Then I should see "Platinum"
  Then I should see "10"
  Then I should see "200"

Scenario: Add package but fill in form incorrectly
  When I fill in "payment_package_name" with "Red"
  And I press "Add package"
  Then I should be on Payment Packages Page
  Then I should not see "Red"
  And I should see "Missing fields"