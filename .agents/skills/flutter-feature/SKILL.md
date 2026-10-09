---
name: flutter-feature
description: Implement or refactor Flutter feature work in Flutter projects using the project's Cubit, GetIt, go_router, network, UI, and validation conventions.
---

# Flutter Feature Work

Use for feature implementation and refactoring under lib/features, lib/core, or lib/app. Follow [AGENTS.md](../../../AGENTS.md) for skill routing, Git workflow, and authorization.

Apply [Clarification Before Action](../../../AGENTS.md#clarification-before-action) whenever uncertainty could lead to an incorrect implementation; ask before the dependent change.

## Workflow

1. Inspect nearby feature code and the task-relevant references below before editing.
2. Identify the smallest set of files that completes the requested behavior; preserve unrelated changes and existing public APIs.
3. Implement through the correct layer. Select tests for the affected feature and directly affected dependencies using the scoped validation policy in AGENTS.md; do not run the full suite unless explicitly requested.
4. Use the review skill before reporting completion; report any unverified behavior or performance claim.

## Architecture

- Use Cubit for new feature state. Apply the Cubit skill when adding or changing Cubits/state classes.
- Preserve nearby folder naming, including presentation/bloc.
- Cubits depend on repository interfaces or small domain services. Dio, ApiClient, Firebase SDKs, DTO parsing, storage, and mapping belong in data/infrastructure.
- Domain exposes contracts, immutable models, and pure validation/policy logic. Prefer XxxModel names; add entities/use cases only when extending an existing local pattern or explicitly requested.
- Keep feature-specific code in its feature and shared feature-agnostic code in core.

## UI Composition

- Page: route/provider/Scaffold shell. View: state handling and composition. Section: major UI group. Component: focused UI element.
- A complete page, view, section, form, card, or other substantial UI must be a widget class, never a widget-returning helper function such as _buildHomeView().
- Put every top-level widget class in its own Dart file, including private widgets such as _HomeView. Give a moved private widget an appropriate public name for import. A `State<T>` companion may stay with its `StatefulWidget`.
- Required build() overrides and small framework builder callbacks are allowed; extract substantial UI from those callbacks into widget classes.
- Split widgets by responsibility and by what changes. File separation alone does not reduce rebuilds.
- Use available layout width and text scale; support keyboard/focus/hover where needed.
- Let app localization govern layout direction. Figma is a visual reference; mixed-language content may need explicit text direction.

## Conditional References

| Task | Read before implementation |
| --- | --- |
| Rebuilds, lists, media, animation, startup, memory, or performance work | [optimization_rules.md](../../../.agent/rules/optimization_rules.md) |
| Responsive layout and custom input/accessibility | [responsive_adaptive_rules.md](../../../.agent/rules/responsive_adaptive_rules.md) |
| Animation or continuous loading motion | [animation_rules.md](../../../.agent/rules/animation_rules.md) |
| Requests, retries, or background delivery | [network_rules.md](../../../.agent/rules/network_rules.md) |
| Auth, sensitive storage, permissions, files, or untrusted input | [security_rules.md](../../../.agent/rules/security_rules.md) |
| Logic tests | [unit-testing.md](references/unit-testing.md) |
| UI tests | [widget-testing.md](references/widget-testing.md) |
| Critical device-level flows with a prepared test environment | [integration-testing.md](references/integration-testing.md) |

## Verification

- Use const where appropriate, lazy lists, scoped state subscriptions, and explicit resource ownership.
- Dispose controllers, focus nodes, subscriptions, renderers, and animation/media resources in their owner.
- Keep secrets and private data out of source, logs, and user-facing errors.
- Run flutter analyze and meaningful targeted tests when practical, passing explicit test file paths or the relevant feature directory. Report the selected scope and commands; do not test unrelated features as a routine completion step.
- For performance claims, follow the measurement workflow; static analysis and functional tests do not establish a speed improvement.
