# Mindful Spending

Mindful Spending is a Flutter personal finance tracker for managing income, expenses, budgets, and category-based spending insights.

## Features

- Add income and expense transactions
- Organize transactions by category
- Set and track a monthly budget
- View dashboard summaries and recent transactions
- Visualize spending with charts
- Export transactions to CSV and PDF
- Store data locally with Hive

## Tech Stack

- Flutter
- Dart
- Provider
- Hive / Hive Flutter
- fl_chart
- intl
- csv
- pdf
- share_plus

## Project Structure

- lib/main.dart: app entry point and provider setup
- lib/app_shell.dart: main navigation shell
- lib/screens/: dashboard, budget, categories, and add transaction screens
- lib/providers/: state management for budget, categories, and transactions
- lib/models/: Hive models and generated adapters
- lib/services/export_service.dart: CSV and PDF export logic

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or VS Code with Flutter support
- A connected device or emulator

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

## Build the APK

To generate a release APK:

```bash
flutter build apk --release
```

The APK will be created at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

If a tracked APK artifact is included in the repository, it will be stored at:

```text
apk/Mindful-Spending.apk
```

## Notes

- Assets are stored under assests/animations/.
- Hive adapters are already generated and used by the app.
- For GitHub activity, a small daily commit workflow can be used to keep the repository active.

## License

No license has been specified yet.
