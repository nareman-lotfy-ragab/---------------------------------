# Quick Start - API Integration Implementation

## What Has Been Done

I've created a complete API integration layer for your Agri-Sense AI Flutter app to connect with the live CropRecommendationAPI. Here's what's included:

### Files Created

1. **`lib/core/services/api_service.dart`** (NEW)
   - Centralized API service for all authentication endpoints
   - Handles HTTP requests and responses
   - Manages JWT token storage and retrieval
   - Includes error handling and response parsing

2. **`lib/features/auth/presentation/bloc/auth_bloc_updated.dart`** (NEW)
   - Updated BLoC with real API integration
   - Replaces mock API calls with actual HTTP requests
   - Handles token persistence
   - Manages authentication state properly

3. **`lib/features/auth/presentation/pages/login_page_updated.dart`** (NEW)
   - Updated login page with API integration
   - Full form validation
   - Remember me functionality
   - Error handling and user feedback

4. **`lib/features/auth/presentation/pages/signup_page_updated.dart`** (NEW)
   - Updated signup page with API integration
   - Full name field added
   - Password confirmation validation
   - Role selection (Farmer/Consultant)
   - Error handling and user feedback

5. **`lib/features/auth/presentation/pages/forgot_password_page_updated.dart`** (NEW)
   - Complete forgot password flow
   - Two-step process: request reset email, then reset password
   - Token input from email
   - Error handling and user feedback

## Implementation Steps

### Step 1: Copy API Service
Copy the API service file to your project:
```bash
cp lib/core/services/api_service.dart <your-project>/lib/core/services/api_service.dart
```

### Step 2: Update Auth BLoC
Replace your existing auth BLoC with the updated version:
```bash
# Backup original
cp <your-project>/lib/features/auth/presentation/bloc/auth_bloc.dart \
   <your-project>/lib/features/auth/presentation/bloc/auth_bloc.dart.backup

# Copy updated version
cp lib/features/auth/presentation/bloc/auth_bloc_updated.dart \
   <your-project>/lib/features/auth/presentation/bloc/auth_bloc.dart
```

### Step 3: Update Authentication Pages
Replace the authentication pages:
```bash
# Login page
cp lib/features/auth/presentation/pages/login_page_updated.dart \
   <your-project>/lib/features/auth/presentation/pages/login_page.dart

# Signup page
cp lib/features/auth/presentation/pages/signup_page_updated.dart \
   <your-project>/lib/features/auth/presentation/pages/signup_page.dart

# Forgot password page
cp lib/features/auth/presentation/pages/forgot_password_page_updated.dart \
   <your-project>/lib/features/auth/presentation/pages/forgot_password_page.dart
```

### Step 4: Verify Imports
Ensure all files import correctly:
- Pages should import: `import '../bloc/auth_bloc.dart';`
- API service should be imported in auth_bloc.dart

### Step 5: Test the Integration

#### Test Registration:
1. Open the app
2. Click "Create New Account"
3. Fill in all fields:
   - Full Name: John Doe
   - Email: john@example.com
   - Password: password123
   - Confirm Password: password123
   - Role: Farmer
4. Click "Create Account"
5. Should navigate to home page on success

#### Test Login:
1. Open the app
2. Enter credentials:
   - Email: john@example.com
   - Password: password123
3. Check "Remember me" (optional)
4. Click "Log In"
5. Should navigate to home page on success

#### Test Forgot Password:
1. Click "Forgot Password?" on login page
2. Enter your email
3. Click "Send Reset Email"
4. Check your email for reset token
5. Enter token and new password
6. Click "Reset Password"

## API Endpoints Used

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/Auth/register` | POST | User registration |
| `/api/Auth/login` | POST | User login |
| `/api/Auth/forgot-password` | POST | Request password reset |
| `/api/Auth/reset-password` | POST | Reset password with token |

## Key Features

✅ **Real API Integration** - Connects to live CropRecommendationAPI
✅ **JWT Token Management** - Automatically handles token storage and retrieval
✅ **Error Handling** - Comprehensive error messages and user feedback
✅ **Form Validation** - Client-side validation for all forms
✅ **Remember Me** - Persists credentials locally with SharedPreferences
✅ **State Management** - Proper BLoC pattern implementation
✅ **Loading States** - Shows loading indicators during API calls
✅ **Token Persistence** - Saves JWT token for authenticated requests

## Configuration

### API Base URL
The API base URL is set in `api_service.dart`:
```dart
static const String baseUrl = 'http://croprecommendationapi.runasp.net/api';
```

To change it, modify this constant in the ApiService class.

### Timeout Configuration
Add timeout to API service if needed:
```dart
static const Duration timeout = Duration(seconds: 30);

// In each request:
final response = await http.post(
  Uri.parse(url),
  headers: headers,
  body: body,
).timeout(timeout);
```

## Data Flow

```
User Input
    ↓
Page (Login/Signup/ForgotPassword)
    ↓
BLoC Event (LoginRequested, SignUpRequested, etc.)
    ↓
ApiService (HTTP Request)
    ↓
CropRecommendationAPI
    ↓
ApiService (Parse Response)
    ↓
BLoC State (AuthAuthenticated, AuthError, etc.)
    ↓
Page (Update UI)
    ↓
User Feedback
```

## Token Management

### Automatic Token Handling
- Token is automatically saved after successful login/registration
- Token is automatically retrieved from SharedPreferences on app start
- Token is automatically included in authenticated requests
- Token is automatically cleared on logout

### Manual Token Operations
```dart
// Set token manually
ApiService.setAuthToken('your_jwt_token');

// Get current token
String? token = ApiService.authToken;

// Clear token
ApiService.clearAuthToken();
```

## Error Handling

All API calls return a consistent response format:
```dart
{
  'success': bool,
  'data': dynamic,
  'message': String,
  'statusCode': int,
}
```

Example:
```dart
final result = await ApiService.login(
  email: 'user@example.com',
  password: 'password123',
);

if (result['success']) {
  print('Login successful');
  print('Token: ${result['data']['token']}');
} else {
  print('Error: ${result['message']}');
}
```

## Common Issues and Solutions

### Issue: "Connection refused"
**Solution**: Verify the API is running at `http://croprecommendationapi.runasp.net/`

### Issue: "Invalid credentials"
**Solution**: Ensure the email and password are correct and the user exists

### Issue: "CORS error"
**Solution**: Check if the API has CORS enabled for your app's domain

### Issue: "Token not working"
**Solution**: Verify token is being saved and retrieved correctly from SharedPreferences

## Next Steps

1. **Test thoroughly** - Run all authentication flows
2. **Add logging** - Implement logging for debugging
3. **Handle edge cases** - Add logic for network errors, timeouts, etc.
4. **Implement refresh tokens** - If API supports token refresh
5. **Add analytics** - Track user authentication events
6. **Secure storage** - Consider using flutter_secure_storage for tokens

## File Structure

```
lib/
├── core/
│   ├── services/
│   │   └── api_service.dart (NEW)
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   └── auth/
│       └── presentation/
│           ├── bloc/
│           │   └── auth_bloc.dart (UPDATED)
│           └── pages/
│               ├── login_page.dart (UPDATED)
│               ├── signup_page.dart (UPDATED)
│               └── forgot_password_page.dart (UPDATED)
```

## Support

For detailed documentation, see: `API_INTEGRATION_GUIDE.md`

For API documentation: `http://croprecommendationapi.runasp.net/swagger/v1/swagger.json`

---

**Ready to integrate?** Follow the implementation steps above and test each flow!
