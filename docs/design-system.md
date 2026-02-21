# MeteoKite Design System (Global)

This file is the global source of truth for UI tokens and reusable component rules.

## Stitch workspace

- Main project: `projects/15704995472041394888`
- DS generation workspace: `projects/14685561787968460399`

Generated DS screens (current set):

- `projects/14685561787968460399/screens/9f160fea890b4584852df3defd6b29c8` (tokens)
- `projects/14685561787968460399/screens/6c398d8dbe084dc38de29aa4a6cd77d7` (typography + iconography)
- `projects/14685561787968460399/screens/5825b873d6214200aeef5b141394db26` (components + states)
- `projects/14685561787968460399/screens/e6872c6b6bf343e4bb5a192cd7614b3f` (accessibility + spacing + elevation)

## Design direction

- Technical + sporty + premium.
- Outdoor readability first (sunlight conditions).
- Light mode is not optional; it is primary for field usage.
- Dark mode is optimized for low light and parity.

## Token system

### Color tokens

Light mode:

- `primary`: `#0F6E8C`
- `secondary`: `#1A8FB3`
- `accent`: `#F4A300`
- `background`: `#F2F7FA`
- `surface`: `#FFFFFF`
- `surfaceVariant`: `#E7EEF3`
- `textPrimary`: `#102A43`
- `textSecondary`: `#334E68`
- `success`: `#1F9D55`
- `warning`: `#C77D00`
- `danger`: `#C62828`
- `windLow`: `#1D9BF0`
- `windMid`: `#0F9D58`
- `windStrong`: `#D9480F`

Dark mode:

- `primary`: `#3BA8C6`
- `secondary`: `#67C0D9`
- `accent`: `#FFC857`
- `background`: `#0B1B26`
- `surface`: `#132735`
- `surfaceVariant`: `#1D3445`
- `textPrimary`: `#EAF3F8`
- `textSecondary`: `#B7CBD8`
- `success`: `#38D996`
- `warning`: `#F5B14C`
- `danger`: `#FF6B6B`
- `windLow`: `#4AB3FF`
- `windMid`: `#45D483`
- `windStrong`: `#FF8A4C`

### Typography tokens

- Heading family: `Barlow Condensed`
- Body family: `Barlow`

Scale:

- `display`: 40 / 44, semibold
- `h1`: 32 / 36, semibold
- `h2`: 28 / 32, semibold
- `h3`: 24 / 28, medium
- `bodyLg`: 18 / 26, regular
- `body`: 16 / 24, regular
- `caption`: 14 / 20, regular
- `overline`: 12 / 16, medium

### Spacing and radius

- Spacing: `4, 8, 12, 16, 24, 32`
- Radius: `8, 12, 16, 24`

### Elevation

- `level0`: no shadow
- `level1`: low card lift
- `level2`: standard card lift
- `level3`: floating control
- `level4`: modal/overlay emphasis

## Iconography system

- Base size: `24px`
- Consistent stroke weight across set
- Semantic colors use status tokens (`success`, `warning`, `danger`)
- No emoji icons in product UI
- Wind/weather icons must preserve visual consistency with app set

## Reusable component contracts

- `WindCompassWidget`
  - Inputs: direction, speed, gust, trend
  - States: default, active, warning
- `WindCard`
  - Inputs: current wind, gust, direction, source freshness
  - States: default, active, warning, error
- `StationCard`
  - Inputs: station name, status, current reading, last update
  - States: default, active, offline
- `SessionStatsCard`
  - Inputs: duration, distance, avg speed, max speed
  - States: default, active
- `AlertBadge`
  - Inputs: threshold type, value, enabled
  - States: default, warning, error

## Accessibility baseline

- Touch targets `>= 44x44`
- Minimum contrast target WCAG AA for body text
- Semantic labels for interactive and data-critical UI
- Reduced motion support for animated sections
- Status must never rely on color only (shape/text/icon support)

## Implementation notes (Flutter)

- Access theme with `Theme.of(context)`
- Use `LayoutBuilder` for responsive adaptation
- Wrap interactive custom widgets with `Semantics`

## References

- `design-system/meteokite/MASTER.md`
- `docs/architecture.md`
