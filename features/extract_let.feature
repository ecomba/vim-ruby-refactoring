Feature: Extract RSpec Let
  Take an assignment in an rspec specfication and convert it into a let declaration

  Scenario: Extract to rspec let declaration
    Given I have an rspec specification with an assignment
    When I extract to rspec let
    Then I see that there is now an rspec let declaration
