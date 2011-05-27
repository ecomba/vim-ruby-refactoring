Feature: Rename Local Variable
  Renames a local variable to be something more meaningful and intention revealing

  Scenario: Rename single occurance of a local variable
    Given I have a single occurance of a local variable
    When I rename the local variable
    Then I see the renamed local variable
