# TalentMatch AI

TalentMatch AI is a cross-platform recruitment assistant built with Flutter for the mobile/client experience and Node.js/Express for the backend API.

## Repository Structure

- `lib/` – Flutter application source code
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` – platform folders for Flutter targets
- `backend/` – backend server with Node.js, Express, and MongoDB support
- `ai_service/` – auxiliary AI tooling and model utilities
- `test/` – Flutter widget and unit tests

## Flutter App

The Flutter app uses:
- `provider` for state management
- `http` for API requests
- `sqflite` for local storage
- `shared_preferences` for simple persisted settings
- `cached_network_image`, `google_fonts`, and `font_awesome_flutter` for UI polish

### Run the Flutter App

1. Install Flutter and set up your device/emulator.
2. From the repo root:
   ```bash
   flutter pub get
   flutter run
   ```

## Backend Server

The backend is located in `backend/` and provides authentication, job management, candidate handling, resume uploads, rankings, and reporting.

### Run the Backend

1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```
2. Create a `.env` file with values such as:
   ```env
   PORT=5000
   MONGO_URI=mongodb://127.0.0.1:27017/talentmatch_ai
   JWT_SECRET=your_secret_key
   JWT_EXPIRE=30d
   NODE_ENV=development
   ```
3. Start the server:
   ```bash
   npm run dev
   ```

## Recommended Workflow

- Start the backend first.
- Then run the Flutter app and point it to the backend API.
- Use the platform-specific folders only when you need custom native behavior.

## Notes

- The project is currently configured as a private Flutter app with `publish_to: none`.
- The backend includes production-ready features such as JWT auth, CORS, and secure password hashing.

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Node.js documentation](https://nodejs.org/)
- [Express documentation](https://expressjs.com/)
- [MongoDB documentation](https://www.mongodb.com/docs/)
 
