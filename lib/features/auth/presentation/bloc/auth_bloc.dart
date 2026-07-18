
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  const LoginRequested(this.email, this.password, {this.rememberMe = false});
  @override
  List<Object?> get props => [email, password, rememberMe];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;
  const SignUpRequested(this.email, this.password, this.fullName, this.role);
  @override
  List<Object?> get props => [email, password, fullName, role];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String token;
  final String newPassword;

  const ResetPasswordRequested(
    this.email,
    this.token,
    this.newPassword,
  );

  @override
  List<Object?> get props => [
    email,
    token,
    newPassword,
  ];
}
class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String email;
  final String role;
  final String? token;
  final String? userId;
  
  const AuthAuthenticated(
    this.email,
    this.role, {
    this.token,
    this.userId,
  });
  
  @override
  List<Object?> get props => [email, role, token, userId];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class PasswordResetSent extends AuthState {}
class PasswordResetSuccess extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final result = await ApiService.login(
        email: event.email,
        password: event.password,
      );

      if (result['success']) {
        final data = result['data'];
        print(data);
        final email = data['email'] ?? event.email;
        final role = data['role'] ?? 'Farmer';
        final token = data['token'];
        final userId = data['user']?['id']?.toString() ?? data['id']?.toString();

        // 1. تحديث ApiService فوراً (مهم جداً للطلبات اللاحقة)
        if (token != null) ApiService.setAuthToken(token);
        if (userId != null) ApiService.setUserId(userId);

        // 2. التعامل مع التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user_name',
          data['user']['fullName'],
        );  
       print("LOGIN FULL NAME = ${data['user']['fullName']}");

ApiService.currentUserName = data['user']['fullName'];

print("API USER NAME = ${ApiService.currentUserName}");
        if (event.rememberMe) {
          await prefs.setString('saved_email', event.email);
          await prefs.setString('saved_password', event.password);
          await prefs.setBool('remember_me', true);
        } else {
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
          await prefs.setBool('remember_me', false);
        }

        // حفظ التوكن ومعرف المستخدم دائماً لاستخدامهما في الجلسة الحالية
        if (token != null) await prefs.setString('auth_token', token);
        if (userId != null) await prefs.setString('user_id', userId);

        emit(AuthAuthenticated(
          email,
          role,
          token: token,
          userId: userId,
        ));
      } else {
        emit(AuthError(result['message'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }
Future<void> _onSignUpRequested(
  SignUpRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());

  try {
    final result = await ApiService.register(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    );

    if (result['success']) {
      // إنشاء الحساب فقط
      // المستخدم لازم يعمل Login بعد كده
      emit(AuthUnauthenticated());
    } else {
      emit(AuthError(result['message'] ?? 'Registration failed'));
    }
  } catch (e) {
    emit(AuthError('Error: ${e.toString()}'));
  }
}

  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await ApiService.forgotPassword(email: event.email);
      if (result['success']) {
        emit(PasswordResetSent());
      } else {
        emit(AuthError(result['message'] ?? 'Failed to send reset email'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

    Future<void> _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final result = await ApiService.resetPassword(
        token: event.token,
        newPassword: event.newPassword,
      );
      if (result['success']) {
        emit(PasswordResetSuccess());
      } else {
        emit(AuthError(result['message'] ?? 'Password reset failed'));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      // لا نحذف البريد وكلمة المرور إذا كان "تذكرني" مفعلاً، فقط نسجل الخروج
      
      ApiService.clearAuthToken();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Error during logout: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatusRequested(CheckAuthStatusRequested event, Emitter<AuthState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getString('user_id');
      final email = prefs.getString('saved_email'); // أو أي طريقة أخرى لحفظ البريد الحالي
      final userName = prefs.getString('user_name');
      final role = prefs.getString('user_role') ?? 'Farmer';

      if (token != null) {
        ApiService.setAuthToken(token);
        if (userId != null) ApiService.setUserId(userId);
        ApiService.currentUserName = userName;
        emit(AuthAuthenticated(
          email ?? '',
          role,
          token: token,
          userId: userId,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<Map<String, dynamic>> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final email = prefs.getString('saved_email') ?? '';
    final password = prefs.getString('saved_password') ?? '';
    return {
      'rememberMe': rememberMe,
      'email': email,
      'password': password,
    };
  }
}

