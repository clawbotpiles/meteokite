# MeteoKite

MeteoKite is an open-source Flutter app for wind sports (kitesurf, wingfoil, windsurf, parawing).

The project starts local-first and evolves to backend-ready without vendor lock-in.

## Core principles

- Local-first in Phase 1
- Clean Architecture + feature-first
- Meteorological precision first, social as optional layer
- Outdoor-ready UX (sunlight contrast, quick readability)
- Open-source quality from day one

## Planned architecture

- State: Riverpod
- Navigation: GoRouter
- Network: Dio
- Local DB: Drift
- Config: `.env`
- Controlled rollout: feature flags

See detailed documents:

- `docs/architecture.md`
- `docs/data-models.md`
- `docs/roadmap.md`
- `docs/contributing.md`
- `docs/design-system.md`

## Design system

- Source of truth generated baseline: `design-system/meteokite/MASTER.md`
- Stitch project: `projects/15704995472041394888`

## Status

STEP 1 is in progress: architecture definition and technical justification before major code implementation.
