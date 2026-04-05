# CryoSafe Implementation Plan

## Goal

Deliver a responsive Flutter application that estimates refrigerator thaw time
for chicken, beef, and fish using a thermodynamics-inspired model.

## Recommended Technologies

- Flutter
- Dart
- `provider`
- `fl_chart`
- Material 3 theming

## Architecture

- `lib/models`
  - Physics and domain objects
- `lib/controllers`
  - UI state and recalculation flow
- `lib/widgets`
  - Reusable input, results, and chart components
- `lib/screens`
  - Responsive page composition
- `lib/theme`
  - Scientific dashboard visual system
- `lib/utils`
  - Formatting helpers

## What To Focus On First

1. Thermodynamics correctness
   - Confirm assumptions around the Newton cooling coefficient.
   - Replace the current simple phase-change plateau with a better thaw model.
   - Create fixed sample scenarios and verify the curve shape.
2. Controller and UX loop
   - Ensure every input updates the output instantly.
   - Guard against unrealistic fridge temperatures and invalid ranges.
3. Visualization quality
   - Improve axis labels, zone backgrounds, and hover tooltips.
   - Make the safe, frozen, and danger regions visually obvious.
4. Platform finishing
   - Add app icons, metadata, platform QA, and packaging.

## Suggested Milestones

### Milestone 1

- Working Flutter shell
- Input controls
- Result card
- Basic line chart
- Initial thaw model

### Milestone 2

- Better thaw physics
- Validation scenarios
- Responsive polish for desktop and mobile

### Milestone 3

- Accessibility pass
- Platform-specific cleanup
- Release preparation

## Notes

The current local Flutter launcher reports a line-ending issue, so the repo was
prepared manually first. Once the toolchain is fixed, the next step is to run
`flutter create .` carefully around the existing source tree or scaffold a fresh
Flutter shell and merge these files in.
