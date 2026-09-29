# F-038 Environment settings and functional settings live apart

| Feature | F-038 |
| --- | --- |
| Name | Environment settings and functional settings live apart |
| Tags | @framework @agent @O-25 @O-16 @O-24 @T-01 |
| File | settings-split-by-what-varies |

Configuration is split by what varies. Settings that differ between deployed environments,
such as connection strings, endpoints, resource names, and credentials, live in an
environment file or the platform's equivalent, one per environment, supplied at deploy time.
Settings that are the same everywhere, such as timeouts, limits, and behaviour, live in the
application configuration committed once. No key appears in both.

## Background

| Step | Text |
| --- | --- |
| Given | a project bootstrapped with "aa init" |
| And | environments named by the infrastructure code |

## F-038-01 Setting up the environment splits the two kinds

| Scenario | F-038-01 |
| --- | --- |
| Name | Setting up the environment splits the two kinds |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | "/aa-dev-setup-environment" writes the configuration |
| Then | an environment template exists per environment with endpoints, connection strings, resource names, and credential placeholders |
| And | the application configuration holds the timeouts, limits, and behaviour settings once |
| And | no key appears in both |

## F-038-02 A new endpoint goes in the environment file

| Scenario | F-038-02 |
| --- | --- |
| Name | A new endpoint goes in the environment file |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket that adds a call to a new external service |
| When | "/aa-dev-implement" adds the service URL |
| Then | the key is added to every environment template with that environment's value or a placeholder |
| And | it is not added to the application configuration |

## F-038-03 A new timeout goes in the application configuration

| Scenario | F-038-03 |
| --- | --- |
| Name | A new timeout goes in the application configuration |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a ticket that adds a request timeout |
| When | "/aa-dev-implement" adds the setting |
| Then | the key is added to the application configuration once |
| And | it is not added to any environment template |

## F-038-04 An agent asked where a setting goes asks which kind it is

| Scenario | F-038-04 |
| --- | --- |
| Name | An agent asked where a setting goes asks which kind it is |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a setting whose kind is not obvious from its name |
| When | "/aa-dev-implement" decides where to put it |
| Then | it asks whether the value differs between environments |
| And | it puts the key in exactly one of the two places accordingly |

## F-038-05 A functional override for one environment is a recorded decision

| Scenario | F-038-05 |
| --- | --- |
| Name | A functional override for one environment is a recorded decision |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a performance environment that needs a longer timeout than every other environment |
| When | the override is made |
| Then | a decision record explains why that environment differs |
| And | the override is a single key in that environment's file citing the record |
| And | the application configuration still holds the default |

## F-038-06 The diff between environments is short

| Scenario | F-038-06 |
| --- | --- |
| Name | The diff between environments is short |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the environment templates for two environments |
| When | they are compared |
| Then | the differences are endpoints, connection strings, resource names, and credentials only |
| And | no functional setting appears in the diff |

## F-038-07 Review catches a setting in the wrong place

| Scenario | F-038-07 |
| --- | --- |
| Name | Review catches a setting in the wrong place |
| Kind | Scenario |
| Tags | @G-48 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a merge request that adds a connection string to the application configuration |
| When | "/aa-dev-review" reviews it |
| Then | a finding says the key varies by environment and belongs in the environment templates |
| And | the finding cites O-25 |

## F-038-08 Environment files are templated, never secret-bearing

| Scenario | F-038-08 |
| --- | --- |
| Name | Environment files are templated, never secret-bearing |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | an environment file holds a credential |
| When | it is committed |
| Then | only the template with a placeholder is committed |
| And | the development environment configuration says where the value comes from |

## F-038-09 Health reports a timeout in every environment file

| Scenario | F-038-09 |
| --- | --- |
| Name | Health reports a timeout in every environment file |
| Kind | Scenario |
| Tags | @R-39 |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a timeout appears in every environment template with the same value and no decision record |
| When | "/aa-fw-health" runs |
| Then | R-39 is reported as unmet with the key named |
