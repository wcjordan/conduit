# Pipes Puzzle — MVP Project Plan

## Concept
An Android puzzle game where players tap grid tiles to rotate pipe segments, connecting them into a single unified network with no dead ends or overlaps. Endless play with gradually increasing difficulty. Relaxed, no-timer experience focused on the satisfaction of solving.

## Core Decisions
| Area | Decision |
|---|---|
| Platform | Android only |
| Framework | Flutter (cross-platform, leaves iOS door open later) |
| Monetization | None for MVP |
| Puzzle generation | Procedural (random spanning tree algorithm) |
| Win condition | Single connected network — all pipes link with no dead ends/overlaps |
| Grid size | Scales with difficulty as player progresses |
| Game loop | Endless single session, no explicit level list |
| Persistence | Save exact puzzle state; resume on relaunch |
| Tile types | Straight, elbow, T-junction, cross |
| Visual style | Minimal/functional for MVP; polish later |
| Timer | None |
| Scoring | Move counter (rotations taken) shown per puzzle |
| Feedback | No haptics/sound for MVP |

## MVP Feature Scope

### 1. Puzzle Generation Engine
- Generate a random spanning tree over an NxN grid (guarantees a solvable, fully-connected layout).
- Map tree edges to required pipe openings per cell → determine correct tile type (straight/elbow/T/cross) per cell.
- Randomly rotate each tile's *starting* orientation so the puzzle isn't pre-solved.
- Track target grid size, increasing every N puzzles solved (e.g. start 4x4, cap growth around 8x8–10x10 for MVP).

### 2. Game Board UI
- Render grid of tiles from puzzle state.
- Tap-to-rotate interaction (90° per tap) with a quick rotation animation.
- Detect and highlight a fully connected network (simple state check after every rotation).
- Win detection → brief completion state → auto-generate and transition to next puzzle.

### 3. Move Counter
- Increment on every tile rotation.
- Display live during play; show final count on puzzle completion.
- (Optional stretch) Track a running best/lowest count per grid size in local stats.

### 4. Persistence
- Serialize current puzzle (grid size, tile types, orientations, move count) to local storage on every change.
- On app launch, restore in-progress puzzle if one exists; otherwise generate a new one.

### 5. Minimal Visual Shell
- Single game screen: grid + move counter + basic app bar.
- Functional dark/light neutral theme — no heavy styling investment yet.

## Explicit Non-Goals for MVP
- No ads/IAP
- No sound or haptics
- No timer or time-based scoring
- No multiple colored-network puzzles (the fancier mode from your screenshot) — possible future mode
- No level list / level select screen
- No difficulty selection — progression is automatic

## Suggested Build Order
1. **Puzzle generation algorithm** (pure Dart, testable independent of UI) — spanning tree → tile types → scrambled orientations.
2. **Board rendering + tap-to-rotate** — get the core interaction feeling good first.
3. **Win detection logic** — connectivity check after each move.
4. **Progression loop** — move counter, next-puzzle transition, grid size scaling.
5. **Persistence layer** — local save/restore of in-progress puzzle.
6. **Pass on minimal visual polish** — spacing, colors, simple animations for rotation/win.

## Open Questions for Later (Post-MVP)
- Difficulty curve tuning: how fast should grid size grow, and should tile-type variety (T/cross frequency) scale too?
- Should there be an undo button, given no scoring penalty exists yet?
- Stats screen — puzzles solved, best move counts?
- Eventually explore the multi-colored-network mode from your reference screenshot as a "hard mode."
