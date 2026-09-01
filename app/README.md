# Ponos

A Flutter client for a personal work and focus tracker. The
same codebase targets Android and the web.

## Current scope

- Responsive Material 3 application shell
- System light/dark theme support
- Main-screen previews for focus areas, streaks, and work statistics
- No backend, persistence, authentication, or state-management dependency yet

## Structure

```text
lib/
  app/
    app.dart                 # Application root
    theme/
      app_colors.dart        # Semantic Ponos palette
      app_radius.dart        # Shape tokens
      app_spacing.dart       # Four-point spacing system
      app_theme.dart         # Material component configuration
  features/
    home/presentation/       # Responsive application shell
  main.dart                  # Entry point
test/
  app_test.dart
```

Each feature can gain its own `domain`, `data`, and `presentation` folders only
when its requirements justify them.

## Design language

Ponos uses a quiet, work-focused visual language. Olive communicates steady
effort, muted bronze marks achievement, and marble/ink neutrals provide a subtle
classical Greek reference. Use semantic colors from `Theme.of(context)` inside
widgets. Use `AppSpacing` and `AppRadius` instead of introducing one-off layout
values. Both light and dark modes are first-class.

## Run

```shell
cd app
flutter pub get
flutter run -d android
flutter run -d chrome
```

## Build

```shell
cd app
flutter build apk
flutter build web
```

The files produced in `build/web` are static frontend assets. Server-side data
storage will be introduced later through an API hosted on the homelab; secrets
and database credentials must not be embedded in this client.
