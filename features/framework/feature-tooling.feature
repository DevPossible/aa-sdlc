# Generated from the knowledge base page Requirements/framework/feature-tooling. Do not edit: change the page, then pull it.
# Checksum: sha256:f0814a8c3d04187b0824254d5c11922260be23930ee6220fda81c89317f6b51f
@agent @T-12 @F-093
Feature: Feature tooling preserves reviewed requirements
  The ten behavior changes approved in the eleven-item backport on 2026-11-02.
  Executable regression coverage and the local approval anchor are in docs/feature-tooling-backport.md.

  @F-093-01
  Scenario: MCP exports preserve every scenario
    Given a feature page exported with Setext headings or empty table headers
    When the page is converted
    Then the Approved output equals the canonical Markdown output including identities steps and examples

  @F-093-02
  Scenario: Malformed requirement tables cannot disappear
    Given a page with malformed duplicate foreign or unconsumed requirement tables
    When the page is converted including a selected subset
    Then conversion fails before generating acceptance output

  @F-093-03
  Scenario: Invalid synchronization sources preserve the batch
    Given existing generated features and a missing Requirements folder invalid page duplicate destination or unsafe filename
    When feature synchronization is requested
    Then it fails before changing any generated file

  @F-093-04
  Scenario: Public tooling modules have versioned manifests
    Given the installed feature converter and snapshot importer
    When their manifests are inspected and imported
    Then each declares its version PowerShell requirement and explicit public exports

  @F-093-05
  Scenario: Snapshot import uses the configured knowledge identity
    Given an offline storage snapshot and the project's configured knowledge space and URL
    When the snapshot is imported
    Then only Approved scenarios generate with the exact page and version provenance
    And invalid metadata wrong spaces and unsupported content are rejected

  @F-093-06
  Scenario: Named entities preserve one reference layer
    Given a storage snapshot containing named numeric and escaped entity references
    When it is imported
    Then recognized references retain their exact text without becoming markup
    And unknown references DTDs and external entities are rejected

  @F-093-07
  Scenario: Simple preamble lists preserve meaning
    Given a storage snapshot containing a simple ordered or unordered preamble list
    When it is imported
    Then item order text and links survive
    And unsupported nesting attributes casing and scenario lists are rejected

  @F-093-08
  Scenario: Snapshot command preserves destination identity
    Given an offline snapshot and an existing generated feature
    When the snapshot command generates or checks its output
    Then source changes downgrades same-version conflicts and hand edits are rejected without replacing existing bytes
    And lost approvals never silently delete the destination

  @F-093-09
  Scenario: Exact Approved scenario selection preserves source order
    Given a fully validated feature page and an explicit list of Approved scenario IDs
    When a component projection is generated
    Then only those scenarios generate in source order with their IDs recorded
    And empty duplicate unknown case-mismatched Draft or Retired selections are rejected

  @F-093-10
  Scenario: Selected output binds the full source
    Given a selected projection bound to its full source Markdown checksum
    When the source selection version or projection metadata changes
    Then the import command rejects same-version conflicts malformed metadata and silent membership changes
    And a newer valid source updates the full-source checksum even when selected steps stay unchanged
