# Technical Contract Index

| Contract | Status | Workflow owner |
|---|---|---|
| [Data contract](data.md) | Approved; implementation tests preserved | `data-contract` + `data-review` |
| Client/server API | Not started | `application-contracts` |
| Authentication and authorization | Not started | `application-contracts` |
| External integrations | Not started | `application-contracts` |
| Events and states | Not started | `application-contracts` |
| Screen/data operations | Not started | `application-contracts` |

The approved data contract is now the authority for later application contracts. Those files must use its identifiers, enums, ownership rules, and lifecycle transitions; failed migration proof may still return the affected implementation ticket for repair.
