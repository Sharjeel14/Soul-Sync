---
name: instruction
description: >
  Plan-first workflow. Before any code change, produce an Implementation Plan
  (understanding, proposed changes, why, impact, alternatives, risks, testing)
  and wait for approval. Enforces project conventions: routing, localization,
  existing state management (no setState), and design tokens.
  Trigger: /instruction.
---

When this skill fires, follow these rules for the rest of the task. Do not edit, create, or delete any files until the user explicitly approves the plan.

## Step 1: Produce an Implementation Plan

The plan must include:

1. **Understanding** — Brief restatement of the request, including assumptions about ambiguous parts.

2. **Proposed Changes** — A list of specific changes, each with:
   - File(s) affected
   - What will change (added / modified / removed)
   - A short code sketch or description (not full implementation yet)

3. **Why This Change Is Needed** — For each change: the problem it solves, the requirement it satisfies, or the risk it addresses.

4. **Impact Analysis** — For each change:
   - Other parts of the codebase affected (dependencies, callers, shared state, config)
   - Behavioral changes visible to users or API consumers
   - Breaking changes (API signatures, data formats, migrations)
   - Performance, security, or backward-compatibility implications
   - Only files directly connected to the change (see "Stay in scope" below)

5. **Alternatives Considered** — If more than one reasonable approach exists, mention the alternatives and why this one was chosen.

6. **Risks & Open Questions** — Unknowns, edge cases, and anything that needs user input before proceeding.

7. **Rollout / Testing Plan** — Tests to add or update, manual checks, and whether the work should be staged.

## Step 2: Mandatory project conventions

These must be reflected in the plan, not just the code.

- **Routing**: Every new screen or dialog must be wired into the app's existing routing/navigation setup. State exactly where the route is registered, its name/path, and how it is navigated to.
- **Localization**: Before adding any user-facing string, check whether the project already has localization/i18n. If it does, add all new strings as translation keys in the existing localization files for every language the project already supports. Never hardcode a string when a localization system exists. If there is no localization setup, say so in the plan and ask whether to use plain strings or set up localization first.
- **State Management**: Detect and use the state management approach already established in the project (e.g. Bloc/Cubit, Riverpod, Provider, GetX). Do not use `setState` at all, under any circumstances, including for local or trivial widget-only UI state. Name the pattern found and confirm the new code follows it consistently with existing modules.
- **Design Tokens**: Do not hardcode colors, spacing, font sizes, or radii. Use the project's existing design tokens/theme system throughout. If a needed value does not exist in the token set, flag it as an open question instead of inventing a one-off value.

## Step 3: Stay in scope — do not look at unrelated files

Do not open, read, search through, or modify files that have no direct connection to the task. Keep the investigation and the changes limited to what the request actually needs.

- Only inspect files that are being changed, or that directly depend on or are depended on by the change (e.g. a caller of a function whose signature changes, the router file where a new screen is registered, the localization files where new strings are added).
- Do not browse unrelated features, modules, or screens "for context", and do not refactor, reformat, rename, or clean up code outside the task.
- If a file seems unrelated but you suspect it is affected, do not open it silently. Name it in Risks & Open Questions with the reason, and ask before touching it.
- The plan must list only the files it will actually touch or needs to read. Anything outside that list stays untouched.

## Step 4: Rules

- Do not write or modify actual code in the planning step — only describe the plan.
- Keep it concise but complete; use bullet points, not long paragraphs.
- If the task is trivial (e.g. a one-line typo fix), skip the full format and state the change and why — but still ask before applying it.
- Wait for "approved", "go ahead", or specific edits to the plan before implementing anything.
- If reality diverges from the plan mid-implementation (different file structure, no localization, a different state management pattern than assumed), stop and flag it instead of improvising silently.