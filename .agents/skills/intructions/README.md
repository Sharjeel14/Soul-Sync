# instruction

Plan first. Code second.

## What it does

Forces the coding agent to produce a full Implementation Plan before touching any file, then wait for approval. The plan explains what will change, why it is needed, and what it affects. It also enforces the project's own conventions instead of the agent's defaults:

- **Routing** — every new screen or dialog is wired into the existing navigation setup
- **Localization** — new strings go into the project's existing translation files for every supported language (no hardcoded strings)
- **State management** — uses whatever the project already uses; `setState` is never allowed
- **Design tokens** — no hardcoded colors, spacing, font sizes, or radii
- **Stay in scope** — does not open, read, or modify files unrelated to the task; only inspects files directly connected to the change and asks before touching anything else

If the agent finds that reality differs from the plan mid-implementation, it stops and flags it rather than improvising.

## How to invoke

```
/instruction
```

Or with a task:

```
/instruction add a profile settings screen with edit and delete-account dialogs
```

## Example output

```
Implementation Plan

1. Understanding
   Add a Profile Settings screen with an edit form and a delete-account dialog.
   Assumption: reuse the existing UserRepository, no new API endpoints.

2. Proposed Changes
   - lib/features/profile/presentation/profile_settings_screen.dart (added)
   - lib/features/profile/cubit/profile_settings_cubit.dart (added)
   - lib/core/routing/app_router.dart (modified: register /profile/settings)

3. Why
   Users need to manage their account; the screen has no entry point today.

4. Impact
   - Router: one new route, no existing paths change
   - UserRepository: read-only usage, no signature changes

5. Alternatives
   Bottom sheet instead of a screen — rejected, form is too long.

6. Risks & Open Questions
   - Token `spacing.xl` does not exist. Use `spacing.lg` or add a new token?

7. Testing
   - Cubit unit tests, widget test for dialog, manual RTL check

Conventions: routing ✔ localization (en, ar keys added) ✔
state management (Cubit, no setState) ✔ design tokens ✔

Waiting for approval.
```

## See also

- [`SKILL.md`](./SKILL.md) — full instruction the agent follows