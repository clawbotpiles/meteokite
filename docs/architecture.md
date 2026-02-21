# MeteoKite Architecture

## STEP 1 - Technical design before coding

MeteoKite follows a local-first architecture in Phase 1, with explicit boundaries so we can add backend sync later without breaking domain logic.

## Architectural decisions and rationale

- `Clean Architecture`: protects business rules from UI and infrastructure churn.
- `Feature-first`: scales by domain area and team ownership.
- `Riverpod`: predictable state, testability, and good composition for async weather streams.
- `GoRouter`: explicit app flow and easy route guards (auth/dev bypass).
- `Dio`: robust HTTP client for retries, interceptors, and standardized errors.
- `Drift`: reliable local source of truth and migration-ready schema.
- `.env`: secrets and environment configuration without hardcoding.
- `Feature flags`: safe rollout for social, tournaments, and advanced modules.

## Layer boundaries

Each feature keeps this structure:

```text
feature/
  domain/
  data/
    local/
    remote/         # placeholder in phase 1
    repositories/
  presentation/
```

Rules:

- UI never depends directly on HTTP or database packages.
- Domain never imports Flutter.
- Data implements interfaces declared in domain.

## App structure target

```text
lib/
  app/
  core/
  shared/
  features/
    auth/
    spots/
      weather/
      stations/
      social/
    profile/
    sessions/
```

## Data flow (phase 1)

1. Presentation triggers use case.
2. Use case requests repository interface.
3. Repository resolves data from Drift local store.
4. Remote adapters exist as placeholders for phase 2.

## Weather provider strategy

- Open-Meteo and AEMET are integrated through provider adapters.
- Both map to canonical domain models (`WindSnapshot`, `ForecastPoint`, `SpotForecast`).
- Unit normalization is centralized (knots, direction degrees, gusts).

## Cross-cutting concerns

- Error model: typed failures (`NetworkFailure`, `ParsingFailure`, `PermissionFailure`, `StorageFailure`).
- Logging: structured logs in core, no prints in features.
- Time zones: all timestamps normalized to `Europe/Madrid` for initial market.
- Geospatial: spot coordinates validated and versioned.

## UX and design system alignment

- Global DS first, then feature screens.
- Outdoor readability constraints:
  - high contrast in light mode
  - touch targets >= 44x44
  - semantic labels for screen readers
  - color never the only status signal

Reference baseline generated at `design-system/meteokite/MASTER.md`.

## Migration path to phase 2

- Keep repositories backend-agnostic.
- Add sync engine behind repository interfaces.
- Add authentication provider adapters without changing domain contracts.
- Enable social and rankings through feature flags.
