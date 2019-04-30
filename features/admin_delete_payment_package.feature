Feature: Delete payment pacakge as a admin

    As a Admin
    I want delete package credits
    So that I can stop offering discounts for buying credits in bulk

Background: Users in the Database
 Given the following users exist:
  | id | name            | email                    | password | membership    | confirmed_at |
  | 500  | Pizza           | pizza@gmail.com       | 12345678 | Administrator         | 2013-02-02 01:00:00 UTC |
  | 501  | Zac             | zac@gmail.com        | asdfjkl; | Club Member         | 2013-02-02 01:00:00 UTC |

Given the following payment_packages exist:
    |id  | name  |   num_classes |   price   |
    | 502  | Green  |   10          |   10      |
    | 503  | Red   |   200         |   2000    |
    | 504  | Blue  |   200         |   2000    |


Scenario: Delete package successfully
  And "Pizza" logs in with correct credentials with password "12345678"
  And I go to Payment Packages Page
  Then I should be on Payment Packages Page
  And I follow "delete_504"
  Then I should be on Payment Packages Page
  Then I should see "Red"
  And I should not see "Blue"
  Then I follow "delete_503"
  Then I should not see "Red"

Scenario: Try to go to package page not as an admin
  And "Zac" logs in with correct credentials with password "asdfjkl;"
  And I go to Payment Packages Page
  Then I should be on the home page
