# MaddyNotes - A Modern Flutter Note-Taking App

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Flutter-blue)
![Firebase](https://img.shields.io/badge/Firebase-integration-orange)
![State%20Management](https://img.shields.io/badge/state-Riverpod-purple)

A clean, modern, and feature-rich note-taking application built with Flutter and Firebase. It offers real-time data sync, offline support, and a user-friendly interface to manage notes efficiently.

***

## 🌟 Features

- **Authentication**: Secure user login and registration using Firebase Authentication.
- **CRUD Operations**: Create, Read, Update, and Delete notes seamlessly.
- **Real-Time Sync**: Notes are instantly synced across all devices using Firestore.
- **Offline Support**: The app is fully functional offline, thanks to Firestore's robust offline persistence. Changes are synced automatically when a connection is restored.
- **Image Attachments**: Add images to your notes from your device's gallery.
- **Color Tagging**: Organize notes with a palette of color tags.
- **Powerful Search**: Quickly find notes by searching through titles.
- **Filter by Color**: Filter your notes based on their assigned color tags.
- **Clean Architecture**: Built on a scalable and maintainable project structure.
- **Modern State Management**: Uses Riverpod for efficient and predictable state management.

## 🛠️ Tech Stack & Tools

- **Framework**: Flutter
- **Programming Language**: Dart
- **Backend & Database**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Riverpod
- **Dependencies**:
    - `image_picker`: For selecting images.

## 📂 Project Structure

The project follows a clean, feature-first architecture to ensure scalability and maintainability.

```
lib/
├── core/
│   ├── animations/     # Custom page transitions
│   ├── constants/      # App-wide constants (colors, keys)
│   ├── theme/          # App theme data
│   ├── utils/          # Utility functions
│   └── widgets/        # Shared widgets (e.g., AuthWidget)
│
├── features/
│   ├── auth/           # Authentication feature
│   ├── notes/          # Notes feature (CRUD, list, search)
│   └── splash/         # Splash screen
│
├── data/
│   └── repositories/   # Repositories for data handling
│
└── main.dart           # App entry point
```

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- **Flutter SDK**: Make sure you have the Flutter SDK installed. [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Firebase Project**: You need a Firebase project to connect the app.
    - Set up a new project in the [Firebase Console](https://console.firebase.google.com/).
    - Enable **Authentication** (Email/Password), **Firestore**, and **Firebase Storage**.
    - Download the `google-services.json` file for Android and place it in the `android/app/` directory.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Premsagar2608/MaddyNotes.git
    cd MaddyNotes
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the app**:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author and Contact
**Name** - PremSagar
**Email** - ps643999@gmail.com
**LINKDIN** - www.linkedin.com/in/prem26sagar
