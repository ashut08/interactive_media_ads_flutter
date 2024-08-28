<p align="center">
  <img src="https://raw.githubusercontent.com/ashut08/interactive_media_ads_flutter
/gifdemo.gif" alt="unitconverter" width="300"/>
</p>
# Interactive Video Player with Skippable Ads using Flutter and Riverpod

This project demonstrates how to build a Flutter video player with skippable ads using the Interactive Media Ads (IMA) SDK. The project uses Riverpod for state management, making it easy to control the ad display and video playback logic.

## Features

-  Interactive Media Ads (IMA) SDK Integration: Display skippable ads before the content video starts.
- Riverpod State Management: Efficient and reactive state management for handling ad display and video playback.
- Skip Ad Functionality: Users can skip the ad and immediately start watching the content video.
- Responsive UI: Clean and responsive user interface with seamless transitions between ads and video content.

## Project Structure


lib/
├── provider/
│   ├── ads_provider.dart
│   ├── show_content_provider.dart
│   └── video_provider.dart
├── screens/
│   └── ad_example_screen.dart
└── widgets/
    └── video_player_widget.dart


- **`provider/`**: Contains state management logic for video, ads, and content visibility.
- **`screens/`**: Contains the main screen where the video and ad interactions occur.
- **`widgets/`**: Contains reusable UI components like the video player widget.

## Getting Started

### Prerequisites

Ensure you have the following tools installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/ashut08/interactive-video-player.git
   ```

2. Navigate to the project directory:

   ```bash
   cd interactive-video-player
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

### Running the App

Run the app on your preferred device or emulator:

```bash
flutter run
```

## Usage

- The app initializes by loading a skippable ad.
- If the ad hasn't been shown before, it plays before the content video starts.
- Users can skip the ad using the "Skip Ad" button, and the content video will start immediately.
- The floating action button allows users to play/pause the video.

## Code Overview

### Providers

- **`video_provider.dart`**: Manages the video player controller.
- **`ads_provider.dart`**: Handles ad loading and interaction.
- **`show_content_provider.dart`**: Tracks whether the ad has been shown before.

### Screens

- **`ad_example_screen.dart`**: The main screen that integrates the video player, ads, and user controls.

### Widgets

- **`video_player_widget.dart`**: A widget that displays the video player.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add a new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.



## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Interactive Media Ads (IMA) SDK](https://pub.dev/packages/interactive_media_ads)
