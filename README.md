# CryoSafe

CryoSafe is a cross-platform Flutter application for estimating how long meat takes to thaw safely in a refrigerator. It combines a modern SaaS-style dashboard with a thermodynamics-inspired thaw model, live controls, and temperature visualization.

## Features

- Cross-platform Flutter app for web, Android, iOS, and desktop-oriented development
- Live thaw-time estimation based on refrigerator temperature, starting temperature, thickness, and meat type
- Temperature vs. time chart built with `fl_chart`
- Frozen, safe, and danger zone visualization
- Responsive dashboard layout
- Staged thaw model with a slowdown around 32°F to simulate phase change

## Tech Stack

- Flutter
- Dart
- `provider` for controller-driven state
- `fl_chart` for charting

## Project Structure

```text
lib/
  controllers/
  models/
  screens/
  theme/
  utils/
  widgets/
docs/
  implementation_plan.md
  ui_spec.md
```

## Running Locally

### Prerequisites

- Flutter installed and available on your `PATH`
- Chrome for the preferred web workflow
- Android SDK if you want Android builds

### Start the app

```bash
flutter pub get
flutter run -d chrome
```

### Useful commands

```bash
flutter analyze
flutter test
flutter run -d linux
flutter build web
```

## Default Dev Workflow

This repo is configured for a web-first workflow in WSL and VS Code.

- VS Code launch target defaults to Chrome
- Preferred local run command:

```bash
flutter run -d chrome
```

If Chrome attach is unreliable in your environment, the practical fallback is:

```bash
flutter run -d web-server --web-port=7357 --web-hostname=0.0.0.0
```

Then open `http://localhost:7357`.

## Thermodynamics Model

The app uses a practical approximation of Newton’s Law of Cooling with staged thaw behavior:

- below 32°F: normal warming behavior
- near 32°F: slowed warming / plateau effect to mimic latent heat during phase change
- above 32°F: warming resumes toward ambient refrigerator temperature

This is intended as a realistic educational estimator, not a laboratory-grade food safety model.

## Deployment

To create a production web build:

```bash
flutter build web
```

Deploy the generated output from:

```text
build/web/
```

Good hosting options:

- Netlify
- Vercel
- Cloudflare Pages
- Firebase Hosting
- GitHub Pages

## Repository Notes

- The codebase is organized around `UI -> Controller -> Model`
- The visual system is documented in [docs/ui_spec.md](./docs/ui_spec.md)
- The implementation roadmap is documented in [docs/implementation_plan.md](./docs/implementation_plan.md)

## Status

Current state:

- responsive Flutter dashboard implemented
- live controller/model flow implemented
- staged thaw model implemented
- analyze and tests passing
- GitHub-ready repo structure in place
