# Technical Contract Index

| Contract | Status | Workflow owner |
|---|---|---|
| [Data contract](data.md) | Approved; implementation tests preserved | `data-contract` + `data-review` |
| [Client/server API](api.md) | Complete for review | `application-contracts` |
| [OpenAPI 3.1 operation inventory](openapi.yaml) | Complete for review | `application-contracts` |
| [Authentication and authorization](auth.md) | Complete for review | `application-contracts` |
| [External integrations](integrations.md) | Complete for review | `application-contracts` |
| [Events and states](events-and-states.md) | Complete for review | `application-contracts` |
| [Normalized errors](errors.md) | Complete for review | `application-contracts` |
| [Screen/data operations](screen-data.md) | Complete for review | `application-contracts` |

The approved data contract is the persistence authority. Application contracts use its identifiers, enums, ownership rules, and lifecycle transitions and are now ready for the dedicated cross-contract review. Failed migration proof may still return the affected implementation ticket for repair.
