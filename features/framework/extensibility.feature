@framework @T-02 @T-01
Feature: /aa-fw-extend helps the user create extensions to the framework
  The core roughs in the framework and expects others to supply the specifics (T-02). /aa-fw-extend
  is the skill that makes supplying them easy: it walks the user from "I need the framework to
  know about X" to a valid, installable extension that follows the tenets, declares its
  requirements, and carries its own feature files.

  Background:
    Given the skills and commands are installed in the agent

  Scenario: Choose the kind of extension
    When I run "/aa-fw-extend"
    Then it asks what the extension is for
    And it offers the kinds: a tech-stack pack, a process pack, a project skill, a target adapter, added guidance, and an added requirement
    And it explains which kind fits the need before scaffolding anything

  Scenario: Scaffold a tech-stack pack
    Given I choose a tech-stack pack for a technology
    When "/aa-fw-extend" scaffolds it
    Then a plugin folder exists with a manifest naming the technology it covers
    And it contains stack-specific guidance for implement, generate-tests, setup-pipeline, and the other steps it extends
    And it may name the tools of that stack, because that is what a plugin is for
    And it declares the requirements those tools imply

  Scenario: Scaffold a process pack
    Given I choose a process pack for an extra step or gate
    When "/aa-fw-extend" scaffolds it
    Then a plugin folder exists with a manifest naming the process it adds to
    And each added step has a skill, a command, and named artifacts
    And the added process is described, not enforced

  Scenario: Scaffold a project skill
    Given I choose a project skill for something specific to this repository
    When "/aa-fw-extend" scaffolds it
    Then a skill folder exists in the project's own skills location
    And it is installed at project scope only
    And "/aa-fw-health" reports it as covering the technology or concern it names

  Scenario: Scaffold a target adapter
    Given I choose a target adapter for an agent the framework does not yet support
    When "/aa-fw-extend" scaffolds it
    Then a target folder exists with templates for where skills and commands are installed
    And it declares whether the target supports commands and hooks
    And the skills themselves are not copied or changed

  Scenario: An extension declares its requirements
    When "/aa-fw-extend" scaffolds any extension
    Then every capability the extension depends on is declared as a requirement in its own numbered range
    And "/aa-fw-health" aggregates those requirements once the extension is installed

  Scenario: An extension carries its own feature files
    When "/aa-fw-extend" scaffolds any extension
    Then the extension has a features folder
    And its behaviour is captured as scenarios before its skills are written
    And the scenarios are tagged with the framework IDs they realise

  Scenario: An extension cannot change core
    Given an extension that redefines a core skill, step, tenet, or opinion
    When "/aa-fw-extend" validates it
    Then the extension is refused
    And the reason names what it tried to change
    And it suggests adding guidance or a new step instead

  Scenario: Core extensions stay tool-neutral
    Given an extension that adds guidance to core steps rather than to a tech-stack pack
    And that guidance names a tool
    When "/aa-fw-extend" validates it
    Then it reports the tenet T-01 violation
    And it suggests moving the guidance into a tech-stack pack

  Scenario: Validate before installing
    When "/aa-fw-extend" finishes scaffolding
    Then it validates the extension's structure, requirements, and feature files
    And it reports every problem with the file that has it
    And it installs the extension at the chosen scope only when validation passes

  Scenario: Share an extension with a team or organisation
    Given a valid extension
    And an organisation config repository is set
    When I ask "/aa-fw-extend" to share it
    Then it adds the extension to the config repository
    And "aa setup" on other machines picks it up at team or enterprise scope

  Scenario: Extend an existing extension
    Given a tech-stack pack is installed
    When I run "/aa-fw-extend" and choose to add to it
    Then it adds the new guidance, step, or requirement to that pack
    And it updates the pack's feature files to match
    And it does not create a second pack for the same technology
