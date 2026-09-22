@framework @fw
Feature: /aa-fw-new-step adds a step with all of its plumbing
  A step is a definition, a command, a skill, scenarios, guidance, and requirements, listed by
  its discipline and any process. The command creates all of it or none of it.

  Background:
    Given I am in the aa-sdlc repository

  Scenario: Add a step to an existing discipline
    When I run "/aa-fw-new-step" with a discipline, a name, artifacts, and guidance
    Then workflow/steps/<step>.yaml exists with a command equal to /aa-<code>-<step>
    And the discipline's steps list includes it
    And a SKILL.md scaffold exists under the discipline's skills folder with matching frontmatter
    And a feature file exists under features/<discipline>/

  Scenario: The id must be unique across disciplines
    Given a step with the same id exists in another discipline
    When I run "/aa-fw-new-step"
    Then it refuses the id and names the existing step

  Scenario: Guidance is promoted only when shared
    Given a guidance item on the new step is identical to one on an existing step
    When I run "/aa-fw-new-step"
    Then the item gets a G-nn id in docs/guidance.md and both steps cite it
    And guidance unique to the new step stays inline

  Scenario: Tool names are refused in core guidance
    Given a guidance item names a product
    When I run "/aa-fw-new-step"
    Then it reports the tenet T-01 violation
    And it suggests declaring a requirement category, or moving the step to a plugin

  Scenario: An anchored step reads first and updates last
    Given the step's anchor is required
    When "/aa-fw-new-step" writes the skill scaffold
    Then the skill body begins with reading the anchor ticket and ends with updating it

  Scenario: The validator gates the addition
    Given the new step would fail "scripts/Test-WorkflowStructure.ps1"
    When I run "/aa-fw-new-step"
    Then the step is not added
    And each validator problem is reported with its file
