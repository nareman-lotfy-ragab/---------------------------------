# Agri-Sense AI - API Integration Guide

## Overview

This guide provides complete instructions for integrating your Flutter authentication UI with the live CropRecommendationAPI at `http://croprecommendationapi.runasp.net/`.

## API Endpoint Details

### Base URL
```
http://croprecommendationapi.runasp.net/api
```

### Authentication Endpoints

#### 1. Register
- **Endpoint**: `POST /api/Auth/register`
- **Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123",
  "fullName": "John Doe",
  "role": "Farmer"
}
```
- **Response** (200/201):
```json
{
  "id": "string",
  "email": "user@example.com",
  "fullName": "John Doe",
  "role": "Farmer",
  "token": "jwt_token_here",
  "resetToken": "string",
  "resetTokenExpiry": "2024-05-08T12:34:56Z",
  "diseaseNotifications": true,
  "communityNotifications": true
}
```

#### 2. Login
- **Endpoint**: `POST /api/Auth/login`
- **Request Body**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Response** (200):
```json
{
  "id": "string",
  "email": "user@example.com",
  "fullName": "string",
  "role": "Farmer",
  "token": "jwt_token_here",
  "resetToken": "string",
  "resetTokenExpiry": "2024-05-08T12:34:56Z",
  "diseaseNotifications": true,
  "communityNotifications": true
}
```

#### 3. Forgot Password
- **Endpoint**: `POST /api/Auth/forgot-password`
- **Request Body**:
```json
{
  "email": "user@example.com"
}
```
- **Response** (200):
```json
{
  "message": "Password reset email sent",
  "resetToken": "string"
}
```

#### 4. Reset Password
- **Endpoint**: `POST /api/Auth/reset-password`
- **Request Body**:
```json
{
  "email": "user@example.com",
  "token": "reset_token_from_email",
  "newPassword": "newpassword123"
}
```
- **Response** (200):
```json
{
  "message": "Password reset successful"
}
```

## Implementation Steps

### Step 1: Update Dependencies

Ensure your `pubspec.yaml` includes the `http` package (already included):

```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.3
  flutter_bloc: ^8.1.6
```

### Step 2: Replace Core Files

The following new files have been created in your project:

#### New Files:
1. **`lib/core/services/api_service.dart`** - API service class for handling all HTTP requests
2. **`lib/features/auth/presentation/bloc/auth_bloc_updated.dart`** - Updated BLoC with real API integration
3. **`lib/features/auth/presentation/pages/login_page_updated.dart`** - Updated login page
4. **`lib/features/auth/presentation/pages/signup_page_updated.dart`** - Updated signup page
5. **`lib/features/auth/presentation/pages/forgot_password_page_updated.dart`** - Updated forgot password page

### Step 3: Integration Instructions

#### Replace the Auth BLoC

Replace the content of `lib/features/auth/presentation/bloc/auth_bloc.dart` with the content from `auth_bloc_updated.dart`:

```bash
# Copy the updated BLoC
cp lib/features/auth/presentation/bloc/auth_bloc_updated.dart lib/features/auth/presentation/bloc/auth_bloc.dart
```

#### Replace the Pages

Replace the authentication pages with the updated versions:

```bash
# Replace login page
cp lib/features/auth/presentation/pages/login_page_updated.dart lib/features/auth/presentation/pages/login_page.dart

# Replace signup page
cp lib/features/auth/presentation/pages/signup_page_updated.dart lib/features/auth/presentation/pages/signup_page.dart

# Replace forgot password page
cp lib/features/auth/presentation/pages/forgot_password_page_updated.dart lib/features/auth/presentation/pages/forgot_password_page.dart
```

#### Update Imports

Ensure your pages import from the correct location. The updated pages import from:
```dart
import '../bloc/auth_bloc_updated.dart';
```

You may need to update this to:
```dart
import '../bloc/auth_bloc.dart';
```

### Step 4: API Service Usage

The `ApiService` class handles all API communication. Key features:

#### Authentication Token Management
```dart
// Set token after login
ApiService.setAuthToken(token);

// Get current token
String? token = ApiService.authToken;

// Clear token on logout
ApiService.clearAuthToken();
```

#### Making API Calls

**Login:**
```dart
final result = await ApiService.login(
  email: 'user@example.com',
  password: 'password123',
);

if (result['success']) {
  final token = result['data']['token'];
  // Handle successful login
} else {
  // Handle error
  print(result['message']);
}
```

**Register:**
```dart
final result = await ApiService.register(
  email: 'user@example.com',
  password: 'password123',
  fullName: 'John Doe',
  role: 'Farmer',
);
```

**Forgot Password:**
```dart
final result = await ApiService.forgotPassword(
  email: 'user@example.com',
);
```

**Reset Password:**
```dart
final result = await ApiService.resetPassword(
  email: 'user@example.com',
  token: 'reset_token',
  newPassword: 'newpassword123',
);
```

## BLoC Events and States

### Events

1. **LoginRequested** - Trigger login with email, password, and remember me option
```dart
context.read<AuthBloc>().add(
  LoginRequested(email, password, rememberMe: true),
);
```

2. **SignUpRequested** - Trigger registration
```dart
context.read<AuthBloc>().add(
  SignUpRequested(email, password, fullName, role),
);
```

3. **ForgotPasswordRequested** - Request password reset email
```dart
context.read<AuthBloc>().add(
  ForgotPasswordRequested(email),
);
```

4. **ResetPasswordRequested** - Reset password with token
```dart
context.read<AuthBloc>().add(
  ResetPasswordRequested(email, token, newPassword),
);
```

5. **LogoutRequested** - Logout user
```dart
context.read<AuthBloc>().add(LogoutRequested());
```

6. **CheckAuthStatusRequested** - Check if user is already authenticated
```dart
context.read<AuthBloc>().add(CheckAuthStatusRequested());
```

### States

1. **AuthInitial** - Initial state
2. **AuthLoading** - Loading state during API calls
3. **AuthAuthenticated** - User is authenticated (contains email, role, token)
4. **AuthUnauthenticated** - User is not authenticated
5. **AuthError** - Error occurred (contains error message)
6. **PasswordResetSent** - Password reset email sent
7. **PasswordResetSuccess** - Password reset successful

## Data Persistence

The updated implementation uses `SharedPreferences` to persist:

- **saved_email** - User's email (if remember me is checked)
- **saved_password** - User's password (if remember me is checked)
- **auth_token** - JWT token for authenticated requests
- **remember_me** - Boolean flag for remember me functionality
- **user_role** - User's role (Farmer/Consultant)

## Error Handling

All API calls return a result map with the following structure:

```dart
{
  'success': bool,
  'data': dynamic,  // Response data if successful
  'message': String,  // Error or success message
  'statusCode': int,  // HTTP status code
}
```

Example error handling:
```dart
if (result['success']) {
  // Handle success
} else {
  print('Error: ${result['message']}');
  print('Status: ${result['statusCode']}');
}
```

## Testing the Integration

### 1. Test Registration
1. Navigate to the signup page
2. Enter valid credentials
3. Select a role (Farmer or Consultant)
4. Click "Create Account"
5. Verify the API response in the console

### 2. Test Login
1. Navigate to the login page
2. Enter registered credentials
3. Optionally check "Remember me"
4. Click "Log In"
5. Verify navigation to home page

### 3. Test Forgot Password
1. Navigate to the forgot password page
2. Enter your email
3. Click "Send Reset Email"
4. Check your email for the reset token
5. Enter the token and new password
6. Click "Reset Password"

## Important Notes

1. **CORS Issues**: If you encounter CORS errors, ensure the API server has CORS enabled for your app's domain.

2. **SSL/TLS**: The API uses HTTP. For production, consider using HTTPS.

3. **Token Expiry**: Implement token refresh logic if the API returns token expiry information.

4. **Network Timeout**: Consider adding timeout configuration to the HTTP client:
```dart
static const Duration timeout = Duration(seconds: 30);
```

5. **Request Validation**: All requests are validated on the client side. Ensure server-side validation is also in place.

## Troubleshooting

### Issue: "Connection refused"
- **Solution**: Verify the API endpoint is running and accessible at `http://croprecommendationapi.runasp.net/`

### Issue: "Invalid email or password"
- **Solution**: Ensure credentials are correct and the user exists in the database

### Issue: "CORS error"
- **Solution**: Check API CORS configuration or use a proxy

### Issue: "Token not persisting"
- **Solution**: Verify `SharedPreferences` is properly initialized and permissions are set

## Next Steps

1. Test all authentication flows thoroughly
2. Implement additional API endpoints (Profile, Recommendations, etc.)
3. Add refresh token logic for better security
4. Implement proper error handling and user feedback
5. Add analytics and logging for debugging

## Support

For API documentation, visit: `http://croprecommendationapi.runasp.net/swagger/v1/swagger.json`

For issues with the Flutter implementation, refer to the BLoC and service documentation.
