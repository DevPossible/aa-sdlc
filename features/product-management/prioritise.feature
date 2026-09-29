# Generated from the knowledge base page Requirements/product-management/prioritise. Do not edit: change the page, then pull it.
# Checksum: sha256:5e833b676b74e60200c53ae78c73f503c686951b99158ff9f2d895699e674bbf
@agent @product-management @O-18 @F-054
Feature: /aa-pd-prioritise orders the backlog and records why
  Order epics and stories by contribution to the outcome, then risk, then cost, rank blocked
  items after what blocks them, and record every move as a comment on the ticket. The ordered
  backlog lives in the ticket system; the reasoning lives on the tickets.

  Background:
    Given a project bootstrapped with "aa init"
    And a backlog of epics and stories in the ticket system with outcomes defined

  @F-054-01
  Scenario: Every item gets a rank and a reason
    When "/aa-pd-prioritise" orders the backlog
    Then every item has a rank
    And every item has a one-line reason on its ticket naming the outcome it serves

  @F-054-02
  Scenario: Blocked items rank after what blocks them
    Given a story depends on another story that is not yet done
    When "/aa-pd-prioritise" orders the backlog
    Then the dependent story is ranked after the story it depends on
    And the dependency is a link between the tickets, not prose

  @F-054-03
  Scenario: Nothing is reordered silently
    Given a story moves from fifth to second
    When "/aa-pd-prioritise" applies the new order
    Then a comment on that ticket says what moved and why

  @F-054-04
  Scenario: An ungrounded size is not treated as a size
    Given a story carries a number with no implementation thinking recorded on it
    When "/aa-pd-prioritise" ranks it
    Then it ranks on a range labelled as a guess
    And the ticket notes that the size needs grounding before an iteration is committed on it

  @F-054-05
  Scenario: Demoting work in progress is a conversation
    Given an item someone is working on would drop out of the current iteration
    When "/aa-pd-prioritise" reaches it
    Then it stops and asks before changing the rank

  @F-054-06
  Scenario: Demoting committed work is a decision record
    Given committed work is demoted with the user's agreement
    When "/aa-pd-prioritise" applies the demotion
    Then a decision record is written, numbered next in the repository's sequence, and linked from the ticket
    And the record is staged and presented, not committed

  @F-054-07
  Scenario: The top of the backlog is not raw ideas
    Given a raw idea ranks high on value
    When "/aa-pd-prioritise" checks the top of the backlog
    Then the idea is sent to refinement with a note on its ticket
    And the top of the backlog contains only items that are ready or in refinement
