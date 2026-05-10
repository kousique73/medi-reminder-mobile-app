# Medi Reminder Mobile App

A comprehensive Flutter mobile application designed to help users track and manage their medicine schedules. It provides timely reminders, stores medical data securely, and integrates with location services.

## 🚀 Key Features

*   **User Authentication:** Secure login and registration using Firebase Auth.
*   **Medicine Reminders:** Schedule and manage medication routines with local notifications (`flutter_local_notifications`).
*   **Cloud Sync & Storage:** All data, including user profiles and schedules, is stored and synced across devices using Firebase Cloud Firestore, Realtime Database, and Firebase Storage.
*   **Location Services:** Integration with Google Maps (`google_maps_flutter`) and Geocoding for finding nearby pharmacies or medical facilities.
*   **Media Handling:** Support for uploading images (`image_picker`) and documents/PDFs (`file_picker`, `flutter_pdfview`).
*   **State Management:** Efficient and reactive UI updates using the `provider` package.
*   **Custom UI/UX:** Responsive design using `sizer`, custom typography with `google_fonts`, and vector graphics with `flutter_svg`.

## 🛠️ Technology Stack

*   **Frontend:** Flutter (Dart)
*   **Backend as a Service (BaaS):** Firebase
    *   Authentication
    *   Cloud Firestore
    *   Realtime Database
    *   Cloud Storage
*   **State Management:** Provider
*   **Local Storage:** Shared Preferences
*   **Maps & Location:** Google Maps Flutter, Geocoding, Location
*   **Notifications:** Flutter Local Notifications, Flutter Native Timezone

## 📁 Project Structure

The core application code is located in the `medicine_reminder_main_file/` directory.

```text
medicine_reminder_main_file/
├── android/             # Android native code
├── ios/                 # iOS native code
├── lib/                 # Main Flutter application code
│   ├── models/          # Data models and classes
│   ├── notifications/   # Local notification configuration and handling
│   ├── provider/        # State management providers
│   ├── screens/         # UI screens and pages
│   ├── utils/           # Helper functions and constants
│   ├── widgets/         # Reusable UI components
│   ├── main.dart        # Application entry point
│   └── firebase_options.dart # Firebase configuration
├── pubspec.yaml         # Project dependencies
└── ...
```

## ⚙️ Getting Started

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version >=2.18.5 <3.0.0)
*   Dart SDK
*   Android Studio / Xcode for emulators
*   A Firebase project configured for Android/iOS

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/kousique73/medi-reminder-mobile-app.git
    cd medi-reminder-mobile-app/medicine_reminder_main_file
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup:**
    *   Ensure you have your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) placed in their respective directories if not already configured via `firebase_options.dart`.

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 📜 License

This project is open-source and available under the terms of the MIT License.
