# F-032 /aa-internal-new-step adds a step with all of its plumbing

| Feature | F-032 |
| --- | --- |
| Name | /aa-internal-new-step adds a step with all of its plumbing |
| Tags | @framework @agent @fw |
| File | new-step |

A step is a definition, a command, a skill, scenarios, guidance, and requirements, listed by
its discipline and any process. The command creates all of it or none of it.

## Background

| Step | Text |
| --- | --- |
| Given | I am in the aa-sdlc repository |

## F-032-01 Add a step to an existing discipline

| Scenario | F-032-01 |
| --- | --- |
| Name | Add a step to an existing discipline |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| When | I run "/aa-internal-new-step" with a discipline, a name, artifacts, and guidance |
| Then | workflow/steps/<step>.yaml exists with a command equal to /aa-<code>-<step> |
| And | the discipline's steps list includes it |
| And | a SKILL.md scaffold exists under the discipline's skills folder with matching frontmatter |
| And | a feature file exists under features/<discipline>/ |

## F-032-02 The id must be unique across disciplines

| Scenario | F-032-02 |
| --- | --- |
| Name | The id must be unique across disciplines |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a step with the same id exists in another discipline |
| When | I run "/aa-internal-new-step" |
| Then | it refuses the id and names the existing step |

## F-032-03 Guidance is promoted only when shared

| Scenario | F-032-03 |
| --- | --- |
| Name | Guidance is promoted only when shared |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a guidance item on the new step is identical to one on an existing step |
| When | I run "/aa-internal-new-step" |
| Then | the item gets a G-nn id in docs/guidance.md and both steps cite it |
| And | guidance unique to the new step stays inline |

## F-032-04 Tool names are refused in core guidance

| Scenario | F-032-04 |
| --- | --- |
| Name | Tool names are refused in core guidance |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | a guidance item names a product |
| When | I run "/aa-internal-new-step" |
| Then | it reports the tenet T-01 violation |
| And | it suggests declaring a requirement category, or moving the step to a plugin |

## F-032-05 An anchored step reads first and updates last

| Scenario | F-032-05 |
| --- | --- |
| Name | An anchored step reads first and updates last |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the step's anchor is required |
| When | "/aa-internal-new-step" writes the skill scaffold |
| Then | the skill body begins with reading the anchor ticket and ends with updating it |

## F-032-06 The validator gates the addition

| Scenario | F-032-06 |
| --- | --- |
| Name | The validator gates the addition |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the new step would fail "scripts/Test-WorkflowStructure.ps1" |
| When | I run "/aa-internal-new-step" |
| Then | the step is not added |
| And | each validator problem is reported with its file |

## F-032-07 A step for authoring the framework is internal

| Scenario | F-032-07 |
| --- | --- |
| Name | A step for authoring the framework is internal |
| Kind | Scenario |
| Tags |  |
| Status | Approved |

| Step | Text |
| --- | --- |
| Given | the step is only meant to be run in the aa-sdlc repository |
| When | I run "/aa-internal-new-step" |
| Then | workflow/steps/<step>.yaml is marked internal with a command equal to /aa-internal-<step> |
| And | the website lists the step on neither the home page nor the methodology page |
