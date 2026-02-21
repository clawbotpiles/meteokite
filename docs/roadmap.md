# MeteoKite Roadmap

## Phase 1 - Local MVP

Goal: usable app without backend.

- Auth
  - email login
  - google/apple structure (placeholders)
  - mandatory dev bypass
- Spots / Weather
  - Open-Meteo forecast
  - AEMET integration
  - wind speed, gusts, direction
  - wind compass visualization
- Spots / Stations
  - curated station list
  - current and historical readings
- Profile
  - equipment management
  - wind alert configuration
- Sessions
  - GPS track, duration, distance
  - average and max speed

## Phase 2 - Advanced layer (design and architecture ready)

- animated heatmap
- webcams
- backend (Supabase or equivalent)
- rankings
- social real sync
- push notifications

## Phase 3 - Competitive system

- global rankings based on sessions
- tournaments (feature-flagged)
  - create tournament
  - join tournament
  - rules
  - winner calculation

## Delivery principles

- ship incrementally
- avoid massive code drops
- keep backend optional until phase 2
- preserve open-source contribution quality
