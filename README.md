# Conduit

An Android puzzle game where players tap grid tiles to rotate pipe segments, connecting them into a single unified network. See [`docs/pipes-app-project-plan.md`](docs/pipes-app-project-plan.md) for the MVP plan and [`docs/scaffolding-plan.md`](docs/scaffolding-plan.md) for the dev env/build system setup.

## Getting Started

Flutter project (Android-only). Requires the Flutter SDK and Android SDK.

### One-time setup

- Install Flutter: `brew install --cask flutter` (or the installer from [flutter.dev](https://flutter.dev)), then run `flutter doctor` — it'll flag anything missing.
- Android toolchain: install Android Studio (gives you the SDK, platform-tools/adb, and an emulator manager) — you don't need Xcode/iOS setup since this project is Android-only.
- Android Studio → Device Manager → create a Pixel AVD.

### Run the app

```
flutter pub get
```

Launch an emulator (via Android Studio's Device Manager, or `flutter emulators --launch <id>`), then:

```
flutter run
```

## Testing

Automated tests live under [`test/`](test) and run with `flutter test`:

```
flutter test
```

No emulator is required — Flutter's test runner uses a headless widget environment.
