# CryoSafe UI Spec

## Design Direction

Scientific dashboard with a clean clinical feel:

- Calm, precise, data-first layout
- Soft slate backgrounds with white analysis panels
- Blue, green, and red used meaningfully for thermal zones
- Large numeric result callout for the thaw estimate
- Responsive from narrow mobile screens to wide desktop dashboards

## Core Color System

- Frozen blue: `#1D4ED8`
- Safe green: `#16A34A`
- Danger red: `#DC2626`
- Ink: `#0F172A`
- Muted text: `#475569`
- Page background: `#F1F5F9`
- Panel background: `#FFFFFF`
- Panel border: `#DCE3EC`

## Typography

- App title: 28 px, semibold
- Panel title: 22 px, semibold
- Result number: 44 px, bold
- Body copy: 15 to 16 px, regular
- Input labels: 14 px, medium
- Chart captions: 12 to 13 px, medium

## Spacing Scale

- 4 px micro spacing
- 8 px tight spacing
- 12 px compact spacing
- 16 px standard spacing
- 20 px panel interior spacing
- 24 px section spacing
- 32 px page rhythm

## Desktop Layout

### Frame

- Recommended canvas width: 1440 px
- Page padding: 32 px
- Main content gap: 24 px
- Max content width: 1360 px

### Structure

- Top app bar
  - Height: 72 px
  - Left aligned title: `CryoSafe`
  - Optional subtitle on desktop: `Safe refrigerator thaw estimation`

- Main dashboard row
  - Left column fixed width: 360 px
  - Right column flexible width
  - Column gap: 24 px

### Left Column: Input Panel

- Card radius: 20 px
- Padding: 20 px
- Vertical gap between controls: 16 px
- Minimum panel height: 520 px

Controls:

- Fridge temperature slider
- Initial meat temperature slider
- Meat thickness slider
- Meat type dropdown
- Optional info block:
  - `Safe target: 41°F`
  - `Phase change modeled near 32°F`

### Right Column: Analysis Area

- Vertical gap: 24 px

#### Result Card

- Height: 148 to 168 px
- Radius: 20 px
- Padding: 20 px
- Left accent rail: 12 px width, full card height minus padding
- Primary content:
  - Label: `Estimated Time To 41°F`
  - Time value in large numeric type
  - Supporting sentence beneath

#### Chart Card

- Minimum height: 420 px
- Radius: 20 px
- Padding: 20 px
- Header row:
  - Title: `Temperature vs Time`
  - Optional legend chips on the right

Chart treatments:

- Smooth line
- Horizontal markers at 32°F and 41°F
- Background bands:
  - Blue tint below 32°F
  - Green tint from 32°F to 41°F
  - Red tint above 41°F
- Bottom axis in hours
- Left axis in °F

## Mobile Layout

### Frame

- Width target: 390 px
- Horizontal padding: 16 px
- Vertical padding: 16 px
- Section gap: 16 px

### Structure

- App bar
- Input panel
- Result card
- Chart card

### Mobile Adjustments

- App bar height: 64 px
- Result number: 36 px
- Chart height: 320 px
- All cards radius: 18 px
- Controls keep full-width layout

## Component Specs

### Slider Blocks

- Label row with current value visible
- Slider track height: 4 px
- Thumb size: 20 px
- Value color should match active thermal accent where useful

### Dropdown

- Height: 56 px
- Radius: 14 px
- Border: 1 px solid `#CBD5E1`

### Legend Chips

- Height: 28 px
- Horizontal padding: 10 px
- Radius: 999 px
- Variants:
  - Frozen
  - Safe
  - Danger

## Motion Notes

- Inputs should update results immediately
- Result card value can animate with a short fade or number transition
- Chart redraw should feel smooth but restrained

## Recommended Build Order

1. Layout shell
   - App bar
   - Desktop and mobile frame behavior
2. Input panel polish
   - Labels
   - spacing
   - card styling
3. Result card emphasis
   - large estimate
   - status rail
4. Chart presentation
   - zones
   - markers
   - legend
5. Final visual refinements
   - shadows
   - type scale
   - transitions

## Flutter Mapping

- `MainScreen`
  - app bar
  - responsive row or list view
- `InputPanel`
  - fixed desktop rail, full width on mobile
- `ResultCard`
  - large estimate callout
- `TemperatureChart`
  - chart card plus zone styling

## Nice-To-Have Follow-Up

- Add a compact summary row under the result:
  - `Starting temp`
  - `Fridge temp`
  - `Thickness`
  - `Meat type`
- Add hover tooltips on the desktop chart
- Add preset buttons for common meats and thicknesses
