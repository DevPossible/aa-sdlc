@framework @agent @O-18 @O-04 @T-04
Feature: Decisions are decision records
  Every significant decision, technical, product, or process, is a decision record: one
  screen, numbered next in one sequence per repository, dated, with context, options,
  decision, and consequences. A record is immutable once accepted; a change of mind is a new
  record that supersedes the old one and links back.

  Background:
    Given a project bootstrapped with "aa init"
    And the decision record location the project config names holds record 0001

  @G-41
  Scenario: A technical decision becomes the next record
    Given a ticket where a technology choice is made
    When "/aa-ta-decide" runs
    Then record 0002 is written in the decision record location
    And it is dated and states context, options considered, the decision, and consequences
    And it is linked from the anchor ticket and the ticket links back

  @G-41
  Scenario: A product decision gets the same form
    Given "/aa-pd-prioritise" demotes an epic that was committed to a date
    When the change of rank is recorded
    Then a decision record is written with the options and the reason
    And the ticket comment cites the record rather than restating it

  @G-41
  Scenario: A process decision from a retrospective is a record
    Given a retrospective agrees to change how the team reviews merge requests
    When "/aa-pm-retrospective" records the action
    Then a decision record captures the context, the options, and the choice
    And the improvement ticket links to it

  @G-41
  Scenario: A change of mind supersedes, never edits
    Given record 0002 is accepted
    When the team later reverses that decision
    Then record 0003 is written stating the new decision and why
    And record 0002 gains only a superseded-by link to 0003
    And the body of record 0002 is unchanged

  @G-41
  Scenario: A decision made mid-implementation is captured
    Given "/aa-dev-implement" discovers that the plan cannot be followed and chooses a different approach
    When the deviation is recorded on the ticket
    Then "/aa-ta-decide" writes a decision record for the choice
    And the plan on the ticket cites the record

  Scenario: The record fits on one screen
    Given a decision whose draft record runs to several pages
    When "/aa-ta-decide" reviews it
    Then it splits the draft into one record per decision
    And each record fits on one screen

  Scenario: The record lives where the config says
    Given the project config names a knowledge base location for decision records
    When a decision record is written
    Then it is created there with the next number in the same sequence
    And it is linked from the anchor ticket exactly as a repository record would be

  @R-32
  Scenario: Health reports an edited record
    Given the content of an accepted decision record was changed after acceptance
    When "/aa-fw-health" runs
    Then R-32 is reported as unmet with the record named
