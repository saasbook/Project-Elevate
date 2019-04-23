Feature: Add payment pacakge as a admin
 
    As a Admin
    I want create package credits
    So that I can offer discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    |
  | 6  | Pizza           | pizza@gmail.com       | 12345678 | Admin         |
And "Pizza" logs in with correct credentials with password "12345678"
And I go to Payment Packages Page
When I fill in "new_package_name" with "Platinum"
And I fill in "new_package_num_classes" with "10"


Scenario: Add package successfully
  And I fill in "new_package_price" with "200"
  And I press "Add package"
  Then I should see "Platinum" within "package_1"
  Then I should see "10" within "package_1"
  Then I should see "200" within "package_1"

Scenario: Add package but fill in form incorrectly
  And I fill in "new_package_price" with "blahbashdfldsadf"
  And I press "Add package"
  Then I should not see "Platinum" within "package_1"
  Then I should not see "10" within "package_1"
  Then I should not see "200" within "package_1"