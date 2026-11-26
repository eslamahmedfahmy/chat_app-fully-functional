# Chat App

A real-time Flutter chat app backed by Firebase, with authentication, media sharing and push notifications.

## Features

- Sign up / sign in with email and Google Sign-In
- One-to-one real-time messaging (Realtime Database + Cloud Firestore)
- Image sharing via Firebase Storage, with save to gallery
- Emoji picker
- Push notifications (Firebase Cloud Messaging)
- User profiles
- Form validation and loading / toast feedback

(TODO: add 4-6 screenshots, add GIF of a live chat.)

## Tech stack

| Area | Technology |
| --- | --- |
| Framework | Flutter, Dart |
| Auth | firebase_auth, google_sign_in |
| Database | cloud_firestore, firebase_database |
| Storage | firebase_storage |
| Notifications | firebase_messaging |
| Other | image_picker, emoji_picker_flutter, cached_network_image, shared_preferences, intl |

## Project structure

```
lib/
├── api/              # Firebase access
├── features/pages/   # screens
├── models/
├── users_profile_info/
├── utils/
└── widgets/
```

## Getting started

1. Create a Firebase project and add Android/iOS apps.
2. Add your own `google-services.json` / `GoogleService-Info.plist` (not included in the repo).
3. Run:

```bash
git clone https://github.com/eslamahmedfahmy/chat_app-fully-functional.git
cd chat_app-fully-functional
flutter pub get
flutter run
```

## Author

**Eslam Fahmy** · [LinkedIn](https://www.linkedin.com/in/eslam-ahmed-fahmy-340220202)
