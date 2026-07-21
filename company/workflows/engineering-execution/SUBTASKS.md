# Subtasks — Read Only When Decomposing

An execution work item should normally already be atomic. If it cannot be completed and verified in one focused turn, decomposition—not partial hidden work—is the selected turn's entire outcome.

## A Valid Subtask

- Produces one concrete outcome.
- Has its own acceptance criteria and verification.
- Names the source ticket or QA/release item it serves.
- Does not weaken the parent contract.
- Can be completed without starting a sibling subtask.

## When to Decompose

Decompose only when the selected work item spans independently verifiable systems or when a required discovery spike must decide the implementation path first.

Do not decompose merely to separate files or routine implementation steps.

## Required Fields

```json
{
  "id": "ENG-001.1",
  "parent_id": "ENG-001",
  "name": "Atomic outcome",
  "description": "What this subtask proves or delivers.",
  "status": "pending",
  "depends_on": [],
  "order": 1,
  "spec_ref": "developer/TASK.md",
  "acceptance_criteria": ["Concrete check"],
  "verification": "Command or review evidence",
  "notes": "",
  "created_at": "ISO-8601",
  "updated_at": "ISO-8601"
}
```

The parent remains `in_progress` until all subtasks and the parent acceptance criteria pass.
