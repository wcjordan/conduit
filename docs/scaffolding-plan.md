# Scaffolding Plan — Dev Env & Build System

Companion to [`pipes-app-project-plan.md`](./pipes-app-project-plan.md). Covers the first implementation step: standing up the Flutter project, dev tooling, and CI before any game logic is written.

## Decisions

| Area | Decision |
|---|---|
| Flutter/Dart SDK | Latest stable (no version pin required) |
| Android min SDK | API 24 (Android 7.0) — reasonable modern floor |
| App display name | Conduit |
| Package id | `com.flipperkid.conduit` |
| State management | Riverpod |
| Persistence | `shared_preferences`, puzzle state serialized to a single JSON string |
| Project structure | Feature-based (`lib/features/<feature>/...`) |
| Linting | `flutter_lints` (default recommended set), enforced via `flutter analyze` |
| Testing | Unit tests (pure logic) + widget tests (board rendering/interaction) |
| CI | GitHub Actions — analyze + test + debug build, on push/PR to `main` |

## Project Structure

```
lib/
  main.dart
  features/
    puzzle/
      models/        # Puzzle, Tile, grid state (pure Dart)
      logic/          # generation, rotation, win-detection (pure Dart)
      providers/      # Riverpod providers wiring logic + persistence to UI
      widgets/        # board, tile, move counter widgets
      screens/        # single game screen for MVP
    persistence/
      puzzle_storage.dart   # shared_preferences read/write + JSON (de)serialization
test/
  features/
    puzzle/
      logic/          # unit tests: generation, rotation, win-detection
      widgets/        # widget tests: board rendering, tap-to-rotate
```

Rationale: MVP is effectively one feature (`puzzle`) plus a thin `persistence` helper. Feature-based structure is chosen for consistency with how the app is expected to grow (stats screen, hard mode) per the project plan's open questions, without over-building now — only the two folders above are created initially.

## Tooling Setup

1. **Flutter project init** — `flutter create` with org `com.flipperkid`, Android-only (skip iOS/web/desktop platform folders for MVP, matching "Android only" decision).
2. **Dependencies** — add `flutter_riverpod`, `shared_preferences`; dev dependency `flutter_lints`.
3. **Linting** — `analysis_options.yaml` extending `package:flutter_lints/flutter.yaml`, default rules (no custom overrides initially).
4. **Formatting** — rely on `dart format` (default settings); no custom line-length config.
5. **App identity** — set display name "Conduit" and package id `com.flipperkid.conduit` in Android manifest/build config; default Flutter launcher icon for MVP (no custom branding yet, per project plan's "minimal visual shell").

## Testing Setup

- `flutter_test` (bundled) for both unit and widget tests.
- Unit tests target `lib/features/puzzle/logic/` — generation produces valid spanning-tree puzzles, rotation updates state correctly, win-detection correctly identifies connected networks.
- Widget tests target `lib/features/puzzle/widgets/` — board renders correct tile count for a given grid size, tap triggers rotation.
- No golden-image / integration (`flutter drive`) tests for MVP — out of scope until visual polish pass.

## CI Setup (GitHub Actions)

Workflow `.github/workflows/ci.yml`, triggered on push and PR to `main`:
1. Checkout, set up Flutter (latest stable).
2. `flutter pub get`
3. `flutter analyze`
4. `flutter test`
5. `flutter build apk --debug` (compile check only, artifact not published)

## Explicit Non-Goals for This Step

- No game logic, puzzle generation, or UI beyond the default Flutter scaffold screen.
- No custom app icon/branding.
- No release signing/build config — debug build only.
- No branch protection rules or PR templates — can revisit once collaboration needs arise.
- No iOS/web/desktop platform setup, even though Flutter leaves the door open later.

## Implementation Stages

Each stage is a separate branch off `scaffolding`, implemented and reviewed independently via a PR back into `scaffolding` (not `main`). Keeps each review small and each step buildable/runnable on its own. Suggested branch names below; merge order is sequential since later stages build on earlier ones.

### Stage 1 — Project init & app identity (`scaffolding-01-init`)
- `flutter create` with org `com.flipperkid`, package id `com.flipperkid.conduit`; strip to Android-only platform folder.
- Set app display name to "Conduit" in Android manifest/build config.
- Verify: default Flutter counter-app boilerplate builds and runs on device/emulator.

### Stage 2 — Dependencies & lint/format config (`scaffolding-02-deps`)
- Add `flutter_riverpod`, `shared_preferences`; dev dependency `flutter_lints`.
- Add `analysis_options.yaml` extending `package:flutter_lints/flutter.yaml` (default rules).
- Verify: `flutter pub get` and `flutter analyze` pass clean on the still-default app.

### Stage 3 — Folder skeleton & placeholder screen (`scaffolding-03-structure`)
- Create feature-based folder skeleton (`lib/features/puzzle/{models,logic,providers,widgets,screens}/`, `lib/features/persistence/`) with placeholder files as needed.
- Replace default counter-app boilerplate with a minimal placeholder screen (empty scaffold, app bar reading "Conduit").
- Verify: app builds/runs showing the placeholder screen instead of the counter demo.

### Stage 4 — Test harness (`scaffolding-04-tests`)
- Add one trivial unit test under `test/features/puzzle/logic/` and one trivial widget test under `test/features/puzzle/widgets/`, exercising the placeholder code from Stage 3.
- Verify: `flutter test` runs and passes both.

### Stage 5 — CI workflow (`scaffolding-05-ci`)
- Add `.github/workflows/ci.yml`, triggered on push and PR to `main` (and to `scaffolding` while this branch is active): `flutter pub get` → `flutter analyze` → `flutter test` → `flutter build apk --debug`.
- Verify: workflow passes on the PR itself.

After Stage 5 merges into `scaffolding`, open a final PR from `scaffolding` into `main`.
