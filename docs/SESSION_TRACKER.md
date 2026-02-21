# MeteoKite Session Tracker

This file keeps a persistent log of what was done in terminal sessions so future sessions can continue without losing context.

## How to use

- Add one entry per work session.
- Keep entries short and action-oriented.
- Include blockers and next steps.

## Session Log

### 2026-02-21 - Foundation, UX components, and infra setup

#### Completed

- Reviewed project structure and architecture alignment with `docs/MeteoKite_Master_Prompt_v2.md`.
- Verified code health with `flutter analyze` and `flutter test`.
- Fixed widget test provider setup in `test/widget_test.dart` by wrapping app with `ProviderScope`.
- Added reusable UI widgets:
  - `lib/shared/widgets/alert_badge.dart`
  - `lib/shared/widgets/wind_compass_widget.dart`
  - `lib/shared/widgets/wind_card.dart`
  - `lib/shared/widgets/station_card.dart`
  - `lib/shared/widgets/session_stats_card.dart`
- Integrated reusable widgets into feature pages:
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/spots/weather/presentation/pages/weather_page.dart`
  - `lib/features/spots/stations/presentation/pages/stations_page.dart`
  - `lib/features/sessions/presentation/pages/sessions_page.dart`
- Centralized wind state classification:
  - `lib/shared/widgets/wind_condition.dart`
- Added tests for wind condition rules:
  - `test/shared/widgets/wind_condition_test.dart`
- Added dual-provider weather integration with AEMET adapter + Open-Meteo fallback:
  - `lib/features/spots/weather/data/remote/weather_remote_data_source.dart`
  - `lib/features/spots/weather/data/remote/aemet_weather_remote_data_source.dart`
  - `lib/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart`
  - `lib/features/spots/weather/data/repositories/weather_repository_impl.dart`
  - `lib/features/spots/weather/presentation/providers/weather_providers.dart`
- Added repository fallback tests:
  - `test/features/spots/weather/data/repositories/weather_repository_impl_test.dart`
- Added local-first weather cache in Drift:
  - `WeatherSnapshots` table and migration to schema v6 in `lib/core/storage/local_database.dart`
  - cache interface + Drift implementation:
    - `lib/features/spots/weather/data/local/weather_local_cache.dart`
    - `lib/features/spots/weather/data/local/drift_weather_local_cache.dart`
  - repository now stores remote snapshots and falls back to cache if remotes fail.
- Added source visibility badge in Weather UI:
  - `lib/shared/widgets/source_badge.dart`
  - integrated in `lib/features/spots/weather/presentation/pages/weather_page.dart`
- Added weather data freshness badge in Weather UI:
  - `lib/shared/widgets/data_freshness_badge.dart`
  - integrated in `lib/features/spots/weather/presentation/pages/weather_page.dart`
- Extended source + freshness badges to Stations UI:
  - `lib/shared/widgets/station_card.dart`
  - `lib/features/spots/stations/presentation/pages/stations_page.dart`
  - updated source mapping in `lib/shared/widgets/source_badge.dart`
- Added real-time wind-alert evaluation over current weather data:
  - alert rule evaluator service in `lib/features/profile/domain/services/wind_alert_evaluator.dart`
  - weather-side provider aggregation in `lib/features/spots/weather/presentation/providers/weather_providers.dart`
  - Weather UI section "Estado de alertas" with active/non-active status in `lib/features/spots/weather/presentation/pages/weather_page.dart`
  - evaluator tests in `test/features/profile/domain/services/wind_alert_evaluator_test.dart`
- Added in-app alert activation notification with debounce:
  - activation helpers in `lib/features/profile/domain/services/wind_alert_activation_notifier.dart`
  - Weather page listener and SnackBar trigger on inactive->active transitions in `lib/features/spots/weather/presentation/pages/weather_page.dart`
  - tests in `test/features/profile/domain/services/wind_alert_activation_notifier_test.dart`
- Added system local notifications for alert activations:
  - notification service in `lib/core/notifications/local_notifications_service.dart`
  - app startup init + permission request in `lib/main.dart`
  - Android notification permission in `android/app/src/main/AndroidManifest.xml`
  - Weather listener now triggers local notification in `lib/features/spots/weather/presentation/pages/weather_page.dart`
- Persisted per-alert debounce state across app restarts:
  - new table `AlertNotificationStates` and schema v7 in `lib/core/storage/local_database.dart`
  - db methods `readAlertLastNotifiedAt` / `writeAlertLastNotifiedAt`
  - Weather listener now checks/stores per-alert notification timestamps via Drift
  - regenerated `lib/core/storage/local_database.g.dart`
- Added alert activation history tracking and UI timeline:
  - new table `AlertNotificationEvents` and schema v8 in `lib/core/storage/local_database.dart`
  - db write/watch methods for notification events
  - weather notification flow now logs per-alert activation events with spot/wind/source
  - provider `alertNotificationHistoryProvider` in `lib/features/profile/presentation/providers/wind_alerts_provider.dart`
  - profile UI section "Historial de activaciones" in `lib/features/profile/presentation/pages/profile_page.dart`
- Added alert history filters and clear action:
  - filters by alert id, spot and date window (1d / 7d / 30d) in providers
  - filtered provider `filteredAlertNotificationHistoryProvider`
  - clear history action via `clearAlertNotificationEvents()`
  - filter controls + clear button in `lib/features/profile/presentation/pages/profile_page.dart`
- Improved clear flow for alert history:
  - confirmation modal with two options: clear all or clear only filtered events
  - filtered clear support in DB via `clearAlertNotificationEventsFiltered(...)`
  - provider action `clearHistoryFiltered(...)`
- Added MVP equipment management in Profile:
  - new table `GearItems` and schema v9 in `lib/core/storage/local_database.dart`
  - CRUD + set-primary methods for gear items in DB
  - providers/actions in `lib/features/profile/presentation/providers/gear_items_provider.dart`
  - profile UI form + list for adding, starring and deleting equipment in `lib/features/profile/presentation/pages/profile_page.dart`
  - regenerated Drift outputs (`lib/core/storage/local_database.g.dart`)
- Linked Sessions with equipment used:
  - `RideSessions` extended with `gearItemId` and `gearLabel` (schema v10)
  - sessions actions now accept optional gear metadata
  - sessions form includes "equipo usado" selector (defaults to primary gear if none selected)
  - recent sessions list now shows the gear label when available
- Added MVP metrics by equipment:
  - gear aggregation provider `gearPerformanceSummariesProvider` in `lib/features/sessions/presentation/providers/sessions_providers.dart`
  - sessions UI section "Rendimiento por equipo" with sessions count, total distance and best speed in `lib/features/sessions/presentation/pages/sessions_page.dart`
- Added CSV export for sessions + gear metrics:
  - export action `exportSessionsCsv(...)` writes to app documents directory
  - sessions UI export button in "Rendimiento por equipo"
  - exported CSV includes session rows and gear summary rows
- Improved mobile export UX:
  - added `share_plus` dependency
  - primary action is now "Exportar y compartir" using native share sheet
  - secondary action keeps "Guardar CSV" for local file storage
- Simplified to mobile-first sharing flow:
  - sessions UI now focuses on `Compartir resumen` (plain-text share sheet)
  - removed file-path-centric UX from the main action
  - shared payload includes sessions count, total distance, best speed and top gear
- Auth placeholders upgraded for MVP continuity:
  - added auth domain contract and sign-in result entity
  - added local auth data source + social remote placeholder data source
  - repository implementation with email/local auth and Google/Apple feature-flag placeholders
  - new auth repository providers for clean wiring
  - login UI now supports email flow + social placeholder buttons + optional dev bypass
  - env flags added: `GOOGLE_AUTH_ENABLED`, `APPLE_AUTH_ENABLED`
- Completed session lifecycle UX with sign-out from profile:
  - added logout action in profile app bar
  - confirmation modal before sign-out
  - sign-out now returns cleanly to `AppRoutes.authLogin`
- Added quick account switching helpers for mobile login:
  - new table `RecentAuthAccounts` and schema v11 in `lib/core/storage/local_database.dart`
  - auth local data source stores and streams recent emails
  - auth repository records recent account on email/social sign-in
  - login screen displays recent email chips for quick account switch
- Upgraded recent account UX in login:
  - replaced simple chips with compact account cards
  - added initials avatar derived from recent email
  - tap on a recent account signs in directly (one-tap account switch)
- Added privacy control for recent accounts:
  - can remove an account from recent list directly in login card trailing action
  - wired through local data source + provider actions + DB delete method
- Improved onboarding speed in setup profile:
  - added optional switch to seed initial gear from discipline presets
  - added `DisciplineGearPresets` constants (`kitesurf`, `wingfoil`, `windsurf`)
  - setup profile now can create starter equipment automatically after profile completion
- Onboarding now sets a default primary gear automatically:
  - gear creation now returns inserted item id
  - first seeded preset in setup profile is automatically marked as primary
  - this makes session logging pick a default gear without extra user steps
- Improved Stations MVP with quick trend summary:
  - added `StationHistorySummary` provider aggregation (latest/avg/min/max/trend)
  - stations page now shows "Resumen rapido" cards before the historical chart
  - keeps historical bars while adding clearer at-a-glance station reading context
- Added station reading quality badge (stable/variable/gusty):
  - new `WindQuality` helper in `lib/shared/widgets/wind_quality.dart`
  - station card now shows reading quality based on `gust - speed` delta
  - tests added in `test/shared/widgets/wind_quality_test.dart`
- Extended station guidance with reading quality context:
  - `WindQuality` now includes a guidance message per quality state
  - station card merges condition guidance + quality guidance for clearer actionability
- Added weather provider strategy selector + fallback traceability:
  - new `WeatherSourcePreference` enum in domain
  - weather repository/usecase now accept preferred source strategy
  - repository now annotates fallback source (`open-meteo(fallback:aemet)`) and keeps cache fallback
  - Weather page includes provider selector and explicit source trace text
  - tests updated for annotated fallback source
- Persisted weather source preference per spot:
  - new table `WeatherSourcePreferences` in local DB (schema v12)
  - DB read/write methods keyed by spot coordinates
  - Weather provider actions now save/load source preference
  - Weather page syncs persisted provider preference when switching spots
- Added UX controls for source preference reset:
  - Weather page shows a warning badge when custom source preference is active
  - added `Restaurar Auto` action to quickly return to default strategy per spot
- Surfaced source preference status in Dashboard:
  - dashboard now warns when active spot is using custom provider strategy
  - added one-tap `Restaurar Auto en este spot` action from dashboard
- Added Dashboard "Estado del sistema" card for MVP observability:
  - reports active source, data age (minutes), freshness bucket, cache/fallback flags
  - shows `Live` vs `Cache` badge and sync/error states
  - complements navigability traffic light with backend/source health context
- Added live GPS session capture for MVP:
  - integrated `geolocator` dependency and mobile location permissions (Android + iOS)
  - new `liveSessionProvider` for start/stop tracking, distance, current/max speed, elapsed time
  - sessions page now includes "Sesion en vivo (GPS)" controls and live status
  - stopping live tracking persists a session summary directly in local sessions history
- Added external session import entrypoint in Sessions:
  - new `ExternalSessionImportService` provider with source adapters (demo: WOO, Garmin/Watch, FIT/GPX)
  - sessions UI now exposes `Conectar dispositivo` and `Importar externa`
  - imported session summary is mapped into local ride sessions with selected/primary gear
- Added first real external file path for imports (GPX):
  - `ExternalSessionImportService.importFromGpxFile()` with file picker + GPX parsing
  - computes duration, distance and average/max speed from track points
  - sessions import sheet now includes `Archivo GPX` (real) plus demo adapters for WOO/Watch
- Added MVP hardening items and release checklist baseline:
  - new `docs/MVP_CHECKLIST.md` with completed scope and pending closure tasks
  - Sessions live GPS UI now includes recovery actions:
    - `Abrir ajustes` when location permission is denied
    - `Activar ubicacion` shortcut when location service is off
    - `Cancelar sesion en vivo` explicit action
- Added executable manual QA playbook for MVP sign-off:
  - new `docs/MVP_MANUAL_QA.md` with device matrix, critical flows, regression smoke and sign-off template
  - linked from `docs/MVP_CHECKLIST.md`
- Added release notes draft for MVP closure:
  - new `docs/MVP_RELEASE_NOTES_DRAFT.md` with highlights, known limitations, flags and QA gate
  - linked from `docs/MVP_CHECKLIST.md`
- Regenerated Drift outputs with build_runner (`lib/core/storage/local_database.g.dart`).

#### Stitch MCP status

- MCP auth, ADC, and project config were repaired successfully.
- `doctor` checks pass with active project `glossy-attic-487711-r2`.
- `generate_screen_from_text` still returns timeout (`-32001`) even after auth fixes.
- Current status: generation endpoint unstable; proceed with Flutter implementation and sync later.

#### GitHub setup

- Local git repo initialized on branch `main`.
- GitHub repository created: `https://github.com/clawbotpiles/meteokite`
- GitHub Project created for tracking: `https://github.com/users/clawbotpiles/projects/1`

#### Next suggested work

- Make dashboard wind chips dynamic using `WindCondition`.
- Add discipline-aware safety guidance in weather/stations views.
- Add initial GitHub Project items (Backlog / In Progress / Done).

### 2026-02-21 - MVP closure pass (hardening + preflight)

#### Completed

- Reviewed MVP pending closure items in `docs/MVP_CHECKLIST.md` and QA plan in `docs/MVP_MANUAL_QA.md`.
- Hardened live GPS no-signal UX in sessions:
  - tracking now downgrades GPS signal to `Sin señal` after 20s without updates in `lib/features/sessions/presentation/providers/live_session_provider.dart`
  - sessions UI now shows explicit guidance when tracking without recent signal in `lib/features/sessions/presentation/pages/sessions_page.dart`
- Hardened GPX import edge cases:
  - added friendly validation error for malformed/corrupted GPX in `lib/features/sessions/presentation/providers/external_session_import_provider.dart`
  - added import timeout handling (12s) with explicit UX message in `lib/features/sessions/presentation/pages/sessions_page.dart`
  - extracted XML parsing entrypoint `importFromGpxXml(...)` for deterministic tests
- Added importer tests in `test/features/sessions/presentation/providers/external_session_import_provider_test.dart`.
- Re-ran preflight checks:
  - `flutter analyze` -> no issues
  - `flutter test` -> all tests passed

#### Pending for full MVP closure

- Physical device QA execution remains pending (Android + iOS) per `docs/MVP_MANUAL_QA.md`.
- GitHub Project still has 0 items: `https://github.com/users/clawbotpiles/projects/1`

### 2026-02-21 - Android emulator QA execution (Pixel 7)

#### Completed

- Launched emulator `emulator-5554` and deployed app successfully.
- Executed guided QA interactions through adb-driven taps/screens:
  - reached onboarding and validated discipline-required behavior
  - completed onboarding and reached Dashboard
  - verified weather spot selector interaction (`Oliva` -> `Piles`)
  - verified provider custom mode UI state (`Preferencia personalizada activa`)
- Captured evidence screenshots under `/tmp/qa_*.png` during run.

#### Findings

- Weather layer returned `Bad state: No weather source available and cache empty` during emulator run.
- Full manual checklist cannot be considered fully complete from scripted adb interaction alone; some flows still require direct interactive execution in emulator UI (share sheet, permission recovery UX, full navigation regression).

#### Outcome

- Android emulator QA status: partial pass.
- iOS physical QA: accepted as non-executable in current local environment.
- MVP decision remains NO-GO until remaining manual checklist items are explicitly completed.

### 2026-02-21 - Weather root-cause fix after emulator QA

#### Root cause

- The Open-Meteo request was sending an invalid `current` variable list including `time`.
- Open-Meteo returned HTTP 400; repository swallowed source errors and ended with `cache empty` message.

#### Fixes applied

- Removed `time` from Open-Meteo `current` query in `lib/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart`.
- Improved repository diagnostics to include attempted source errors when all remotes fail in `lib/features/spots/weather/data/repositories/weather_repository_impl.dart`.
- Added tests:
  - `test/features/spots/weather/data/remote/open_meteo_weather_remote_data_source_test.dart`
  - updated `test/features/spots/weather/data/repositories/weather_repository_impl_test.dart`

#### Verification

- `flutter test` (targeted weather tests) passing.
- `flutter analyze` passing.
- Re-deployed on emulator and confirmed dashboard now shows live weather source (`open-meteo(fallback:aemet)`) instead of cache-empty fatal state.

### 2026-02-21 - UI navigation restructure (tabs + new distribution)

#### Completed

- Reworked app navigation to a tabbed shell with independent branch stacks:
  - tabs: `Dashboard`, `Spots`, `Grabar`, `Perfil`
  - implemented via `StatefulShellRoute.indexedStack` in `lib/app/router/app_router.dart`
  - shell UI in `lib/app/navigation/main_shell_page.dart`
- Updated route map for the new structure in `lib/app/router/app_routes.dart`:
  - `/dashboard`, `/spots`, `/record`, `/profile`
  - moved sessions detail to `/record/sessions`
- Added new root screens per tab:
  - spots hub in `lib/features/spots/presentation/pages/spots_page.dart`
  - recording hub in `lib/features/sessions/presentation/pages/record_page.dart`
- Redistributed dashboard content in `lib/features/dashboard/presentation/pages/dashboard_page.dart`:
  - keeps weather/system + sessions summary + quick actions
  - removes primary recording entrypoint from dashboard
- Updated smoke widget test expectation in `test/widget_test.dart` for the new dashboard composition.

#### Verification

- `flutter analyze` passing.
- `flutter test` passing (full suite).
- Emulator screenshots captured for each tab (`/tmp/mvp_*_new.png`).

### 2026-02-21 - Post-navigation UI fixes

#### Completed

- Fixed profile tab overflow with long content:
  - switched profile body to `SafeArea + SingleChildScrollView`
  - added bottom padding to coexist with bottom navigation bar
  - file: `lib/features/profile/presentation/pages/profile_page.dart`
- Removed global overscroll "spring/bounce" effect across the app:
  - added custom scroll behavior in `lib/app/app.dart`
  - uses `ClampingScrollPhysics` and disables overscroll indicator globally.

#### Verification

- `flutter analyze` passing.
- widget smoke test passing.
- visual check on emulator confirms profile no longer shows `BOTTOM OVERFLOWED` and scrolling behavior is clamped.

### 2026-02-21 - Spots FAB + add manual spot cards

#### Completed

- Updated `Spots` tab UX to card-based spot management in `lib/features/spots/presentation/pages/spots_page.dart`.
- Added bottom-right `FloatingActionButton` (`+`) to add spots manually.
- Implemented predictive search modal for available spots (name/province filter over `SpainInitialSpots.all`).
- Added "Mis spots" card list:
  - each added spot appears as a new card immediately
  - active spot is marked with `Activo` chip
  - each card has actions for `Meteo` and `Estaciones`
- Selecting a spot from the add flow also updates `selectedWeatherSpotProvider` so downstream weather/stations views open on that spot.

#### Verification

- `flutter analyze` passing.
- `flutter test test/widget_test.dart` passing.

### 2026-02-21 - Spots cards UX polish (empty state + add animation)

#### Completed

- Updated spots initial state to start with an empty user list (`Mis spots`) and explicit empty-state card in `lib/features/spots/presentation/pages/spots_page.dart`.
- Added empty-state CTA (`Anadir spot`) to trigger the same predictive picker flow as the FAB.
- Added subtle card-entry animation when a new spot is added (fade + small upward slide) using `AnimatedSwitcher` keyed by list length.

#### Verification

- `flutter analyze` passing.
