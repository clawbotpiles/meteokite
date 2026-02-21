# MeteoKite MVP Manual QA

Goal: close Phase 1 pending validation on real devices.

## Test matrix

- Android physical device (GPS + notifications + file picker)
- iOS physical device (GPS + notifications + file picker)

## Pre-flight

1. Run local checks:
   - `flutter analyze`
   - `flutter test`
2. Build and install debug app on device.
3. Ensure network is available for weather requests.

## Critical flow checklist

Mark each item as PASS/FAIL with notes.

### A. Auth and onboarding

- [ ] Login with email works.
- [ ] Recent account appears after login.
- [ ] Recent account can be removed from login list.
- [ ] Setup profile requires discipline selection.
- [ ] Optional gear seeding creates starter equipment.

### B. Weather and source strategy

- [ ] Spot selector changes wind reading.
- [ ] Source selector persists per spot after app restart.
- [ ] `Restaurar Auto` returns to default strategy.
- [ ] Dashboard warns when custom source is active.
- [ ] Source trace displays expected values (`aemet`, `open-meteo`, `cache:*`, `fallback`).

### C. Stations

- [ ] Current station card renders speed, gust, direction.
- [ ] Reading quality badge appears (`estable/variable/racheada`).
- [ ] Historical bars render without crash.

### D. Alerts

- [ ] Alert creation works from profile.
- [ ] Alert evaluation appears in weather screen.
- [ ] In-app notification appears when alert transitions inactive->active.
- [ ] Local OS notification appears once (debounce respected).
- [ ] Alert history records activation events.
- [ ] Filter and clear history actions work (all + filtered).

### E. Sessions (manual + live GPS + import)

- [ ] Manual session save works and appears in list.
- [ ] Live GPS start works with permission granted.
- [ ] Live GPS shows elapsed time and distance updates.
- [ ] Stop and save stores live session.
- [ ] Cancel live session resets state safely.
- [ ] Permission denied path shows `Abrir ajustes` recovery.
- [ ] Location off path shows `Activar ubicacion` recovery.
- [ ] Import external demo paths (WOO/Watch) create sessions.
- [ ] Import real GPX creates session summary.

### F. Share and profile/equipment

- [ ] Share session summary opens native share sheet.
- [ ] Equipment add/edit primary/delete works.
- [ ] Session uses selected/primary equipment.
- [ ] Equipment performance cards update after new sessions.

## Regression smoke before MVP sign-off

- [ ] Launch app from cold start.
- [ ] Navigate Dashboard -> Weather -> Stations -> Sessions -> Profile.
- [ ] No blocking errors in normal usage.
- [ ] Core actions complete in under 2-3 taps each.

## Sign-off template

Fill this after execution:

- Android QA: PASS/FAIL
- iOS QA: PASS/FAIL
- Known issues accepted for Phase 2: <list>
- MVP Phase 1 decision: GO / NO-GO

## Last execution (2026-02-21)

Environment: Android emulator Pixel 7 (`emulator-5554`).

Result snapshot:

- PASS: setup profile screen reached and discipline is required before continue.
- PASS: dashboard loads after onboarding.
- PASS: weather spot selector changes selected spot (Oliva -> Piles).
- PASS: weather provider selector supports custom strategy and shows custom warning state.
- FAIL: weather source fetch returns `Bad state: No weather source available and cache empty` (no live/cached meteo data).
- PARTIAL: full critical-flow checklist cannot be completed reliably only through adb scripted taps (share sheet, system permission recovery UX, full cross-screen manual behavior still needs direct manual interaction in emulator UI).

Working decision for this run:

- Android QA (emulator): PARTIAL PASS
- iOS QA: accepted by local-environment limitation (no physical iOS available in this PC)
- MVP decision: NO-GO until remaining manual checks are completed interactively and weather source availability is validated.

Follow-up (same date): weather source availability issue was fixed in code (invalid Open-Meteo query field), and emulator verification now shows live/fallback weather data instead of `cache empty` fatal state.
