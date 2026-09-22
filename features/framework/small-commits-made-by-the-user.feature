@framework @O-17 @O-02 @T-06
Feature: Small, cohesive commits, made by the user
  Every commit is one understandable change, small enough to review in one sitting. The agent
  never makes the commit unless the user asked for that commit. It stages the change, writes
  the message, presents the staged diff and the message, and stops. Reviewing the change
  before it is committed is the primary point at which a person directs the work.

  Background:
    Given a project bootstrapped with "aa init"
    And a ticket being implemented on a branch

  @G-40
  Scenario: A step ends staged, not committed
    Given the user asked to implement the ticket and said nothing about committing
    When "/aa-dev-implement" reaches a green build with a cohesive change
    Then the change is staged
    And a commit message is written in the configured format
    And the staged diff summary and the message are presented to the user
    And no commit is made

  @G-40
  Scenario: The user asks for the commit
    Given a staged change and a presented message
    When the user says to commit it
    Then the commit is made under the user's source control identity
    And it carries no attribution to an agent
    And the next change starts a new staging round

  @G-40
  Scenario: A request to finish is not a request to commit
    Given uncommitted changes on the branch
    When "/aa-dev-finish-branch" runs without a request to commit
    Then it stages the remaining change and presents it
    And it reports that the branch cannot be finished until the user commits
    And it does not commit on the user's behalf

  @G-40
  Scenario: A framework authoring command ends staged
    Given I am in the aa-sdlc repository
    When "/aa-fw-new-opinion" finishes its checks
    Then every changed file is staged as one change set
    And the proposed commit message is presented
    And the command does not commit unless the user asked it to in this invocation

  @G-39
  Scenario: A change that bundles two concerns is split before staging
    Given the working tree contains a bug fix and an unrelated refactor
    When "/aa-dev-implement" prepares the commit
    Then two staged change sets are presented in turn, each with its own message
    And neither message needs the word "and" to describe its change

  @G-39
  Scenario: Review flags a commit that needs a tour
    Given a merge request with one commit touching three unrelated areas
    When "/aa-dev-review" reviews it
    Then a finding names the commit and says it should be split
    And the finding cites guidance G-39

  Scenario: The stance holds for one person or fifteen
    Given a solo developer running an agent on a personal project
    When the agent reaches a green build
    Then it still stages and presents rather than committing
    And the developer reviews the diff before committing it themselves

  @R-31
  Scenario: Health reports agent-made commits
    Given a commit on the default branch was made under an agent identity or with an agent attribution
    When "/aa-fw-health" runs
    Then R-31 is reported as unmet with the commit listed
