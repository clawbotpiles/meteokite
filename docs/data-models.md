# MeteoKite Data Models (Phase 1)

## Domain entities

- `UserProfile`
  - `id`, `email`, `displayName`, `preferredDiscipline`, `createdAt`
- `Spot`
  - `id`, `name`, `province`, `lat`, `lon`, `countryCode`, `isFavorite`
- `WindSnapshot`
  - `spotId`, `timestamp`, `speedKn`, `gustKn`, `directionDeg`, `source`
- `ForecastPoint`
  - `spotId`, `timestamp`, `speedKn`, `gustKn`, `directionDeg`, `rainMm`
- `StationReading`
  - `stationId`, `timestamp`, `speedKn`, `gustKn`, `directionDeg`
- `Session`
  - `id`, `userId`, `spotId`, `startedAt`, `endedAt`, `durationSec`, `distanceKm`, `avgSpeedKn`, `maxSpeedKn`
- `WindAlert`
  - `id`, `userId`, `spotId`, `minSpeedKn`, `maxSpeedKn`, `directionMinDeg`, `directionMaxDeg`, `startHour`, `endHour`, `enabled`

## Local persistence notes

Drift tables planned:

- `users`
- `spots`
- `forecasts`
- `station_readings`
- `sessions`
- `wind_alerts`
- `feature_flags`

Design principles:

- Favor immutable domain models.
- Keep DB schema additive and migration-safe.
- Store provider raw payload only if needed for debugging.

## Provider mapping

- Open-Meteo -> canonical weather fields
- AEMET -> canonical weather fields
- No provider-specific types outside `data/remote`.

## Future-ready fields (phase 2+)

- `syncState` (`local_only`, `pending_sync`, `synced`)
- `remoteId`
- `lastSyncedAt`
- `deletedAt` (soft delete for conflict-safe sync)
