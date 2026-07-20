# Technical Contract Index

| Contract | Status | Workflow owner |
|---|---|---|
| [Data contract](data.md) | Approved; implementation tests preserved | `data-contract` + `data-review` |
| [Client/server API](api.md) | Approved after cross-contract review | `application-contracts` + `contracts-review` |
| [OpenAPI 3.1 operation inventory](openapi.yaml) | Approved; 49/49 operations | `application-contracts` + `contracts-review` |
| [Exact success response schemas](schemas.yaml) | Approved after validation | `application-contracts` + `contracts-review` |
| [Schema-conforming operation examples](examples.yaml) | Approved; 49/49 validated | `application-contracts` + `contracts-review` |
| [Authentication and authorization](auth.md) | Approved after cross-contract review | `application-contracts` + `contracts-review` |
| [External integrations](integrations.md) | Approved after cross-contract review | `application-contracts` + `contracts-review` |
| [Events and states](events-and-states.md) | Approved after cross-contract review | `application-contracts` + `contracts-review` |
| [Normalized errors](errors.md) | Approved after cross-contract review | `application-contracts` + `contracts-review` |
| [Screen/data operations](screen-data.md) | Approved; complete mapping | `application-contracts` + `contracts-review` |

The approved data contract is the persistence authority. Application contracts use its identifiers, enums, ownership rules, and lifecycle transitions and passed the dedicated cross-contract review recorded in [contracts-review.md](../contracts-review.md). Failed implementation or migration proof may still return the affected ticket or owning contract for repair.
