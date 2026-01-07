# Rastro

Flutter application for tracking shipping packages from multiple Argentine courier services.

## Overview

**Rastro** is a cross-platform Flutter application that allows users to track their shipments from various Argentine courier services (Correo Argentino, Andreani, OCA) in a single unified interface.

## Features

- Multi-courier support for Argentine shipping services
- Clean, intuitive Material Design 3 interface
- Real-time shipping status visualization
- Cross-platform support (Android, iOS, Web, Windows, Linux, macOS)

## Quick Start

```bash
# Install dependencies
flutter pub get

# Generate required code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Documentation

For detailed information about the project, see:

- [docs/README.md](docs/README.md) - Project overview and features
- [docs/SETUP.md](docs/SETUP.md) - Installation and setup guide
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - Architecture and design patterns
- [docs/API.md](docs/API.md) - API documentation and data models
- [docs/CLAUDE.md](docs/CLAUDE.md) - Developer guide for Claude Code
- [docs/changelog.md](docs/changelog.md) - Version history and changes

## Technology Stack

- Flutter 3.10+
- Dart 3.10+
- State Management: Flutter BLoC
- Routing: AutoRoute
- Dependency Injection: GetIt

## Project Status

Currently in active development. The app uses mock data for demonstration. Integration with real courier APIs is planned for future releases.

## License

Private project - Not for publication on pub.dev
