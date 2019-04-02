Feature: Log in to different types of accounts
 
  As an user of this app
  So that I can confirm my account
  I want to see which account I am in

Background: I am an user already in the account

  Given I signed up in the account
  # or I am already in the database
  And I am on the RottenPotatoes home page

Scenario: restrict to movies with 'PG' or 'R' ratings
  # enter step(s) to check the 'PG' and 'R' checkboxes
  # enter step(s) to uncheck all other checkboxes
  # enter step to "submit" the search form on the homepage
  # enter step(s) to ensure that PG and R movies are visible
  # enter step(s) to ensure that other movies are not visible
  When I check the following ratings: PG, R
  And I uncheck the following ratings: G, PG-13
  And I press "ratings_submit"
  Then I should see "The Incredibles"
  And I should see "The Terminator"
  And I should not see "Alladin"
  And I should not see "The Help"