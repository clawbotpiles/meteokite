# MeteoKite MVP Checklist (Phase 1)

Status date: 2026-02-21

## Scope

Target: local-first mobile MVP usable without backend.

## Acceptance Checklist

- [x] Auth local flow (email) functional
- [x] Google/Apple auth structure in place (feature-flag placeholder)
- [x] Dev bypass available for fast development
- [x] Spot weather with Open-Meteo
- [x] AEMET integration with fallback strategy
- [x] Source traceability (live/fallback/cache)
- [x] Station list + current readings + local historical view
- [x] Profile management (discipline + equipment)
- [x] Wind alerts configuration and live evaluation
- [x] Alert activation notifications (in-app + local notification)
- [x] Session registration (manual)
- [x] Session registration in live mode (GPS start/stop)
- [x] Equipment linked to sessions
- [x] Session summary sharing (mobile-first)
- [x] External import entrypoint in Sessions
- [x] Real GPX file import (v1)

## Remaining to call MVP fully complete

- [ ] Device validation pass on physical Android and iOS (permissions, location behavior, background edge cases)
- [ ] UX hardening for live GPS/session import edge states (timeouts, malformed GPX, no-signal long sessions)
- [ ] Final product QA pass with a short regression checklist and release notes draft

Progress note (2026-02-21):

- Implemented hardening slice in codebase:
  - GPX malformed/corrupt file handling with friendly error
  - GPX import timeout feedback in Sessions UX
  - live GPS no-signal detection + on-screen guidance while tracking
- Executed Android emulator QA pass (Pixel 7) with partial result:
  - onboarding validation + spot/source controls verified
  - weather fetch currently failing in emulator with `No weather source available and cache empty`
  - full interactive checklist still pending direct manual execution (share sheet, permission recovery paths, full navigation regression)
- iOS physical QA is accepted as not executable in current local environment.

Execution guide: `docs/MVP_MANUAL_QA.md`

## Exit Criteria

MVP Phase 1 is considered done when the 3 remaining items are checked and verified on real device tests.

Release notes draft: `docs/MVP_RELEASE_NOTES_DRAFT.md`
