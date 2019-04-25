Feature: Update payment pacakge as a admin
 
    As a Admin
    I want update package credits
    So that I can offer discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page
And I fill in "payment_package_name" with "Red"
And I fill in "payment_package_num_classes" with "10"
And I fill in "payment_package_price" with "200"
And I press "Add package"
Then I follow "edit_1"

Scenario: Edit package successfully
  When I fill in "payment_package_name" with "AMAZING DEAL"
  And I fill in "payment_package_num_classes" with "15"
  And I fill in "payment_package_price" with "250"
  And I press "Update package"
  Then I should be on Payment Packages Page
  Then I should see "AMAZING DEAL"
  Then I should see "15"
  Then I should see "250"
  And I should not see "Red"
  And I should not see "10"
  And I should not see "200"

Scenario: Add package but fill only change one form
  When I fill in "payment_package_name" with "Blue"
  And I press "Update package"
  Then I should be on Payment Packages Page
  Then I should see "Blue"
  Then I should see "10"
  Then I should see "200"