@framework @agent @O-10 @T-07
Feature: A size is grounded in implementation thinking
  No unit of work carries a size or an effort estimate that is not backed by written thought
  about how it will be built: what changes, what is unknown, what could go wrong. The depth
  matches the stakes. The framework does not say when the thinking happens or who does it;
  it says a number without it is a guess, labelled as one and never recorded as the size.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket whose scenarios are linked and whose questions are answered
    And the ticket has no size

  @G-28
  Scenario: A ticket is sized from written implementation thinking
    When "/aa-rf-refine-ticket" sizes the ticket
    Then the ticket first records what changes, what is unknown, and what could go wrong
    And the size is recorded on the ticket after that reasoning
    And the size cites the reasoning as its basis

  @G-28
  Scenario: The depth of thinking matches the stakes
    Given one ticket changes a label and another changes a payment flow
    When each is sized
    Then the label ticket's reasoning is a sentence naming the file that changes
    And the payment ticket's reasoning is a full implementation plan
    And both sizes cite their reasoning

  @G-28
  Scenario: A number asked for before any thinking is a labelled guess
    Given the ticket has no written thought about how it will be built
    When a size or estimate is requested for it
    Then the answer is a range labelled as a guess
    And no size is recorded on the ticket
    And the ticket is not reported as ready

  @G-28
  Scenario: An iteration is not committed on a guess
    Given a ticket carries a size with no reasoning behind it
    When "/aa-pm-plan-iteration" considers it
    Then the ticket is reported as not ready
    And it is not committed to the iteration
    And the reason names the missing reasoning

  Scenario: The implementation plan checks the size
    Given a sized ticket whose reasoning was a short sketch
    When "/aa-ip-plan-implementation" produces a plan that reveals more than the sketch saw
    Then the size on the ticket is revised
    And the revision says what the plan found that the sketch did not

  @R-23
  Scenario: Health reports sizes with nothing behind them
    Given sized tickets in the configured project have no implementation thinking recorded
    When "/aa-fw-health" runs
    Then R-23 is reported as unmet with those tickets listed
