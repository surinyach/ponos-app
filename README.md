# Ponos

A minimal Flutter foundation for a personal work and objectives tracker. The
same codebase targets Android and the web.

## Current scope

- Responsive Material 3 application shell
- System light/dark theme support
- Placeholder areas for overview, objectives, focus cycles, and progress
- No backend, persistence, authentication, or state-management dependency yet

## Structure

```text
lib/
  app/
    app.dart                 # Application root
    theme/app_theme.dart     # Shared visual theme
  features/
    home/presentation/       # Responsive application shell
  main.dart                  # Entry point
test/
  app_test.dart
```

Each feature can gain its own `domain`, `data`, and `presentation` folders only
when its requirements justify them.

## Run

```shell
flutter pub get
flutter run -d android
flutter run -d chrome
```

## Build

```shell
flutter build apk
flutter build web
```

The files produced in `build/web` are static frontend assets. Server-side data
storage will be introduced later through an API hosted on the homelab; secrets
and database credentials must not be embedded in this client.
