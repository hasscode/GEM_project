---
name: flutter-code-review
description: Review Flutter changes in Flutter projects for correctness, architecture, security, performance, responsiveness, and missing tests.
---

# Flutter Code Review

Use for requested Flutter reviews and a scoped review before completing implementation. Follow [AGENTS.md](../../../AGENTS.md); keep review-only work read-only.

Apply [Clarification Before Action](../../../AGENTS.md#clarification-before-action) when intended behavior or evidence is uncertain; clarify before relying on it in a finding or taking a dependent action.

## Review Checks

- Verify requested behavior, boundaries, errors, and realistic regressions with concrete file/line evidence.
- Check presentation/domain/data separation, repository contracts, and Cubit dependency injection.
- Check async closure, obsolete results, duplicate submissions, immutable state collections, and retained data during refresh against [flutter-cubit](../flutter-cubit/SKILL.md).
- Each top-level widget class has its own Dart file; a `State<T>` companion may share its `StatefulWidget` file. Flag substantial UI hidden in widget-returning helper functions, including large builder callbacks.
- Inspect rebuild scope, lazy lists, image/media memory, animations, and lifecycle ownership using [optimization_rules.md](../../../.agent/rules/optimization_rules.md) when relevant.
- Distinguish a plausible performance risk from a measured regression. Request/report measurement for performance claims; do not claim improvement from fewer files, widgets, or const additions alone.
- Check available-space layouts, text scale, localization/direction, focus/keyboard behavior, and accessibility using [responsive_adaptive_rules.md](../../../.agent/rules/responsive_adaptive_rules.md) where applicable.
- For requests and background delivery, use [network_rules.md](../../../.agent/rules/network_rules.md): bounded retries, backoff, replay safety, cancellation, and an observable final failure.
- For auth/storage/files/permissions/input changes, use [security_rules.md](../../../.agent/rules/security_rules.md). For an explicit comprehensive audit, read [security-audit.md](references/security-audit.md) and its full checklist.
- Check meaningful behavior coverage with [unit-testing.md](../flutter-feature/references/unit-testing.md) or [widget-testing.md](../flutter-feature/references/widget-testing.md), rather than requiring a line-coverage percentage.
- Apply AGENTS.md's scoped validation policy: select tests for the changed feature and directly affected dependencies. Do not require or run unrelated feature tests or the full suite as a routine review/completion gate; a full suite needs an explicit user request.
- Distinguish project-convention violations from correctness, security, or performance defects; do not invent runtime impact for a style issue.

## Output

1. Findings ordered by severity with evidence, impact, and a practical correction.
2. Open questions or assumptions.
3. Validation commands, selected test scope and results, and concrete limits, including missing performance measurements.

Say clearly when no actionable findings are found. Avoid unrelated rewrites or a full audit for every small change.
