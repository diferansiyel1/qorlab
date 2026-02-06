# QorLab Agent Instructions

These instructions apply to the entire repository.

## Source of truth (read first)

1. `PROJECT_CONSTITUTION.md` (non‑negotiable architectural laws)
2. `IMPLEMENTATION_PLAN.md` (MVP → Production plan; execution order and acceptance gates)

If anything conflicts, follow `PROJECT_CONSTITUTION.md`.

## Mandatory workflow

- Do not implement production work that materially changes architecture/data flows unless it is aligned with `IMPLEMENTATION_PLAN.md`.
- If a task requires deviating from `IMPLEMENTATION_PLAN.md`, update the plan first and get explicit user approval.
- Database migrations must be additive. Never delete/rename existing persisted fields or collections.
- Offline‑first always: UI must not call remote APIs directly; the app must remain functional without internet.
- Scientific precision: do not use `double` for chemistry/units/dose/molarity logic. Use `decimal` (store decimals as strings in persistence/archives when needed).

## Product defaults

- Default language is English. All new user-facing strings must be routed through localization (`packages/core/localization`), even if only English is provided initially.
- No user accounts / no cloud dependency by default. Data portability is via encrypted `.ql` archives (see `IMPLEMENTATION_PLAN.md`).

