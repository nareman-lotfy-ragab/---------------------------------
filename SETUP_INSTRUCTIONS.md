# Agri-Sense AI - Setup Instructions

## 🚀 Ready to Run!

This project has been fully integrated with the live CropRecommendationAPI. All authentication endpoints are now connected and ready to use.

## ✅ What's Included

- ✅ Real API integration with `http://croprecommendationapi.runasp.net/`
- ✅ JWT token management and persistence
- ✅ Complete authentication flow (Login, Register, Forgot Password)
- ✅ Form validation and error handling
- ✅ Remember me functionality
- ✅ Full BLoC state management

## 📋 Prerequisites

- Flutter SDK (3.5.0 or higher)
- Dart SDK (3.5.0 or higher)
- Android Studio / Xcode (for mobile development)
- Internet connection (for API calls)

## 🔧 Installation Steps

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d web

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux
```

### 3. Build for Production
```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# macOS
flutter build macos

# Linux
flutter build linux
```

## 🔐 Authentication Flow

### 1. Register New Account
1. Click "Create New Account" on login page
2. Enter full name, email, password
3. Select role (Farmer or Consultant)
4. Click "Create Account"
5. Automatically logged in and redirected to home

### 2. Login
1. Enter email and password
2. Optionally check "Remember me"
3. Click "Log In"
4. Redirected to home page on success

### 3. Forgot Password
1. Click "Forgot Password?" on login page
2. Enter your email
3. Click "Send Reset Email"
4. Check your email for reset token
5. Enter token and new password
6. Click "Reset Password"

## 📁 Project Structure

```
agri_sense_ai/
├── lib/
│   ├── core/
│   │   ├── services/
│   │   │   └── api_service.dart          (NEW - API Integration)
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── presentation/
│   │   │   │   ├── bloc/
│   │   │   │   │   └── auth_bloc.dart    (UPDATED - API Integration)
│   │   │   │   └── pages/
│   │   │   │       ├── login_page.dart   (UPDATED - API Integration)
│   │   │   │       ├── signup_page.dart  (UPDATED - API Integration)
│   │   │   │       └── forgot_password_page.dart (UPDATED)
│   │   ├── home/
│   │   ├── crop_recommendations/
│   │   └── ... (other features)
│   └── main.dart
├── pubspec.yaml
├── API_INTEGRATION_GUIDE.md              (Detailed documentation)
├── QUICK_START_IMPLEMENTATION.md         (Quick reference)
└── SETUP_INSTRUCTIONS.md                 (This file)
```

## 🔌 API Configuration

The API base URL is configured in `lib/core/services/api_service.dart`:

```dart
static const String baseUrl = 'http://croprecommendationapi.runasp.net/api';
```

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/Auth/register` | POST | User registration |
| `/api/Auth/login` | POST | User login |
| `/api/Auth/forgot-password` | POST | Request password reset |
| `/api/Auth/reset-password` | POST | Reset password with token |

## 🧪 Testing

### Test Credentials (Create your own)
1. Register a new account with test email
2. Use the registered credentials to login
3. Test "Remember me" functionality
4. Test forgot password flow

### Common Test Scenarios
- ✅ Valid registration with all fields
- ✅ Login with correct credentials
- ✅ Login with incorrect credentials (error handling)
- ✅ Remember me persistence
- ✅ Password reset flow
- ✅ Token persistence across app restarts

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 🔒 Security Features

- ✅ JWT token management
- ✅ Secure token storage with SharedPreferences
- ✅ Password validation (min 6 characters)
- ✅ Email validation
- ✅ HTTPS ready (configure in production)
- ✅ Token expiry handling

## 🐛 Troubleshooting

### Issue: "Connection refused"
**Solution**: Verify the API is running at `http://croprecommendationapi.runasp.net/`

### Issue: "Invalid credentials"
**Solution**: Ensure the email and password are correct

### Issue: "CORS error"
**Solution**: Check API CORS configuration

### Issue: "Token not persisting"
**Solution**: Verify SharedPreferences permissions are set

### Issue: Build errors
**Solution**: Run `flutter clean` and `flutter pub get`

## 📚 Documentation

- **API_INTEGRATION_GUIDE.md** - Detailed API documentation and implementation details
- **QUICK_START_IMPLEMENTATION.md** - Quick reference for developers
- **SETUP_INSTRUCTIONS.md** - This file

## 🚀 Next Steps

1. Run `flutter pub get` to install dependencies
2. Run the app with `flutter run`
3. Test all authentication flows
4. Customize the UI as needed
5. Deploy to your desired platform

## 📞 Support

For API documentation: `http://croprecommendationapi.runasp.net/swagger/v1/swagger.json`

For Flutter documentation: `https://flutter.dev/docs`

## 📝 Version Info

- **Flutter Version**: 3.5.0+
- **Dart Version**: 3.5.0+
- **API Version**: CropRecommendationAPI v1
- **Last Updated**: May 2026

---

**Ready to go!** Run `flutter pub get` and `flutter run` to start the app.
