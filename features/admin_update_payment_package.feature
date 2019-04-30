Feature: Update payment pacakge as a admin
 
    As a Admin
    I want update package credits
    So that I can offer discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    | confirmed_at |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         | 2013-02-02 01:00:00 UTC |
Given the following payment_packages exist:
    |id  | name  |   num_classes |   price   |
    | 7  | Green  |   10          |   10      |
    | 5  | Red   |   200         |   2000    |
    | 6  | Blue  |   200         |   2000    |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page
Then I follow "edit_5"

Scenario: Edit package successfully
  When I fill in "payment_package_name" with "AMAZING DEAL"
  And I fill in "payment_package_num_classes" with "15"
  And I fill in "payment_package_price" with "250"
  And I press "Update package"
  Then I should be on Payment Packages Page
  Then I should see "AMAZING DEAL"
  And I should not see "Red"

Scenario: Add package but fill only change one form
  When I fill in "payment_package_name" with "Blue"
  And I press "Update package"
  Then I should be on Payment Packages Page
  Then I should see "Blue"
  Then I should see "10"
  Then I should see "200"