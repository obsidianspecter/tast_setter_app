

```markdown
# Task Setter App

## Overview

The **Task Setter App** is a simple and minimalistic task management application built with **Flutter**. This app allows users to:

- Add tasks with a minimal interface.
- Cross off tasks once completed.
- Toggle between **dark mode** and **light mode**.
- Save and persist task data using **Hive** (local database).
- Automatically adjust to the system theme settings.
- The app maintains a smooth and fluid user experience with clean animations.

## Features

- **Add Tasks**: Add new tasks with a single button press.
- **Mark Tasks as Completed**: Tasks can be marked completed with a simple tap. Completed tasks are crossed out with a line-through animation.
- **Theme Toggle**: Users can toggle between dark and light modes. The app will persist the theme even after the app is closed and reopened.
- **Persistent Task Storage**: Tasks are saved using **Hive** local database, ensuring they are retained even after restarting the app.
- **System Theme Sync**: The app defaults to the system theme setting if no user preference is saved.

## Prerequisites

Before running this app, ensure that you have the following installed:

- **Flutter** (2.0 or higher)
- **Dart** (2.10 or higher)
- **Hive** package for persistent local storage
- **Path Provider** package for accessing device storage
- **Android Studio** or any IDE with Flutter support

## Installation

### 1. **Clone the Repository**

Clone this repository to your local system using the following command:

```bash
git clone <repository-url>
```

### 2. **Install Flutter**

If Flutter is not already installed on your system, follow these steps:

- **For macOS**: [Flutter Install](https://flutter.dev/docs/get-started/install/macos)
- **For Windows**: [Flutter Install](https://flutter.dev/docs/get-started/install/windows)
- **For Linux**: [Flutter Install](https://flutter.dev/docs/get-started/install/linux)

### 3. **Install Dependencies**

Navigate to the project directory and run:

```bash
flutter pub get
```

This will fetch the required dependencies.

### 4. **Run the App on Your System**

You can run the app directly on an emulator or connected device using the following command:

```bash
flutter run
```

### 5. **Build and Install on Android/iOS Device**

To install and run the app on a physical Android/iOS device:

#### For Android:
1. Connect your Android phone via USB or use an emulator.
2. Run the following command to build the APK:

```bash
flutter build apk
```

3. Install the APK on your phone using:

```bash
flutter install
```

#### For iOS (macOS Only):
1. Connect your iPhone or use an iOS simulator.
2. Run the following command:

```bash
flutter build ios
```

3. Install the app on your device using:

```bash
flutter install
```

## Usage

- **Open the app** and you will see a **list of tasks**.
- **Add a task** by tapping the floating action button (a "+" icon).
- **Mark a task as complete** by tapping on it. A line-through will appear, and it will be marked as completed.
- **Delete a task** by tapping the trash icon next to it.
- **Change the theme** by tapping the theme toggle icon in the app bar (a sun/moon icon). The app will remember your theme preference between sessions.
- **The system theme** will be used by default if no user preference is set.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

---

### Instructions in the README:
- **App Description**: Detailed the app's features and functionality.
- **Installation**: Included steps to install dependencies, run the app on a system, and install on both Android and iOS devices.
- **Usage**: Described how users can interact with the app (adding tasks, marking them as completed, etc.).
- **Contributing**: Explained how others can contribute to the project.

This README should help anyone to install, run, and understand your app, as well as contribute to its development.
