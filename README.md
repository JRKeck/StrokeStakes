# StrokeStakes

A Flutter application for managing golf betting games and score tracking.

## Features

- Player Management
- Hole-by-Hole Score Tracking
- Animal Scoring (Snakes, Gorillas, Camels, Frogs)
- Greenie and Wad Tracking
- Game Setup and Configuration
- Real-time Score Updates and Totals
- Comprehensive Payout Calculations

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (for iOS development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/JRKeck/StrokeStakes.git
```

2. Navigate to the project directory:
```bash
cd StrokeStakes
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/           # Core functionality, utilities, and constants
├── config/         # App configuration, routes, env
├── features/       # Feature-specific code
│   ├── score_calculation/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── widgets/
│   │   └── screens/
│   ├── player_management/
│   ├── game_setup/
│   └── payouts_card/
├── services/       # Global services (Hive, etc.)
├── shared/        # Shared widgets and utilities
├── styles/        # Theme and styling
└── main.dart
```

## Assets

The app uses the following asset structure:

```
assets/
├── images/         # App images and icons
├── fonts/          # Custom fonts
└── icons/          # App icons
```

## Development Guidelines

Please refer to [PROJECT_RULES.mdc](PROJECT_RULES.mdc) for detailed development guidelines and best practices.

## Game Rules

### Scoring
- **Animals**: Track Snakes, Gorillas, Camels, and Frogs on each hole
- **Greenies**: Record birdie, par, or bogey+ results
- **Wads**: Track wad ownership and counts
- **Zookeeper**: Special scoring when a player collects all animals

### Payouts
- Animal payouts based on total counts and Zookeeper status
- Greenie payouts vary by result (2x for birdie, 1x for par)
- Wad payouts calculated per nine holes
- All payouts automatically calculated at game end

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Josh Keck - [@JRKeck](https://github.com/JRKeck)
