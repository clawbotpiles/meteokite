# MeteoKite MVP - Release Notes (Draft)

Version: 0.1.0-mvp
Date: TBD

## Highlights

- Local-first wind app for kitesurf / wingfoil / windsurf without backend dependency.
- Weather integration with source strategy and fallback:
  - AEMET / Open-Meteo selection
  - cache fallback
  - source traceability in UI
- Stations experience:
  - current reading
  - recent history
  - trend + reading quality indicators
- Profile and safety:
  - equipment management
  - wind alert configuration
  - alert activation notifications (in-app + local notification)
  - alert activation history with filters
- Sessions:
  - manual session logging
  - live GPS session capture (start/stop/cancel)
  - external session import entrypoint
  - first real GPX import path
  - equipment-linked session metrics
- Mobile sharing:
  - native share sheet for session summary

## Known limitations (accepted for MVP)

- No backend sync yet (Phase 2 scope).
- Social auth providers are placeholders gated by feature flags.
- External device connectors (WOO/watch APIs) are not live yet; GPX path is the first real importer.
- Live GPS behavior in harsh/no-signal conditions depends on device/OS.

## Flags / runtime notes

- `DEV_BYPASS_ENABLED`
- `GOOGLE_AUTH_ENABLED`
- `APPLE_AUTH_ENABLED`

## QA sign-off gate

This release must only be marked as GO after:

1. `docs/MVP_MANUAL_QA.md` executed on physical Android + iOS
2. All critical checklist items PASS
3. Known issues reviewed and accepted for Phase 2
