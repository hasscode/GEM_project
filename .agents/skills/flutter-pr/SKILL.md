---
name: flutter-pr
description: Draft branch names, conventional commit messages, and pull request descriptions for Flutter project changes.
---

# Flutter PR Drafting

Use when the user requests branch, commit, or PR text. Follow [AGENTS.md](../../../AGENTS.md) for actual Git actions; drafting text does not authorize staging, committing, pushing, or publishing a PR.

Apply [Clarification Before Action](../../../AGENTS.md#clarification-before-action) when scope, claims, or Git actions are uncertain; ask before the dependent action and keep unverified claims explicit.

## Names And Messages

- Draft branch names as `codex/<type>-<short-description>`; follow an explicit user-provided name.
- Types: feat, fix, refactor, perf, chore, test, docs.
- Commit format: `<type>(<scope>): <imperative summary>`; keep the summary under 72 characters when practical.
- Do not create another branch merely to draft its name.
- If Git state is unavailable, draft from inspected changes and state that limit.

## PR Description

Describe the final change for someone who has not read the chat. Lead with the problem and resulting behavior, then include relevant validation and material risks. Use the repository template when present; avoid boilerplate for a small change.

For performance work, report the measurement scenario, platform, and before/after results, or explicitly say performance is unverified. Describe migrations, auth/data implications, or rollout considerations when they actually apply.
