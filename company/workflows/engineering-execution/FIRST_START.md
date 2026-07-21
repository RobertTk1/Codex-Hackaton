# First Start — Read Only When `tasks.json` Is Missing

The checked-in `tasks.json` is normally authoritative. If it is missing, initialization is the only work allowed that turn.

## Restore the Scaffold

Create or recover:

```text
GOAL.md
tasks.json
progress.txt
FIRST_START.md
SUBTASKS.md
WORKFLOW.md
developer/
  TASK.md
  references/
qa/
  TASK.md
  references/
devops/
  TASK.md
  references/
references/
  verification.md
  sources.md
  state-contract.md
```

Recover `loop_status` and current stage from version history plus the authoritative queues. Do not infer status from an empty replacement file. If history cannot prove the state, initialize as `blocked` and record the missing authority.

## End the Turn

Validate `tasks.json`, verify or regenerate `ticket-index.json`, append a real-timestamped recovery entry to `progress.txt`, and stop.
