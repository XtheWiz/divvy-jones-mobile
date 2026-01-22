# Divvy Jones - Expense Splitting App

A pirate-themed expense splitting app built with Flutter. Split bills, track group expenses, and settle up with your crew! 🏴‍☠️

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)

## 📱 Features

- **Sign In / Sign Up** - Pirate-themed authentication with mascot illustrations
- **Home Dashboard** - Balance overview, quick actions, recent activity
- **Groups** - Create and manage expense groups
- **Add Expense** - Split bills with category selection
- **Profile** - User settings and statistics
- **Demo Mode** - Pre-filled credentials for testing

## 🎨 Design

Extracted from Figma with:

- **Primary Gradient**: `#B7AEFF` → `#8C7DF4`
- **Font**: Inter (Google Fonts)
- **Components**: Custom buttons, text fields, navigation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10+
- Android Studio / Xcode

### Installation

```bash
git clone git@github.com:XtheWiz/divvy-jones-mobile.git
cd divvy-jones-mobile
flutter pub get
flutter run
```

### Demo Credentials

```
Email: demo@divvyjones.com
Password: demo123
```

## 📁 Project Structure

```
lib/
├── core/           # Theme, constants, services
├── shared/         # Reusable widgets
├── features/       # Auth, home, groups, expense, profile
├── app.dart        # Router
└── main.dart       # Entry point
```

## 📦 Dependencies

| Package      | Purpose          |
| ------------ | ---------------- |
| google_fonts | Inter typography |
| flutter_svg  | SVG support      |
| go_router    | Navigation       |

## 📄 License

MIT License

---

Made with 💜 by [Wirkx](https://github.com/XtheWiz)
