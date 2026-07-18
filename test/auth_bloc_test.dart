import 'package:flutter_test/flutter_test.dart';
import 'package:agri_sense_ai/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc();
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    test('emits [AuthLoading, AuthAuthenticated] when LoginRequested is successful', () async {
      final expected = [
        AuthLoading(),
        const AuthAuthenticated('user@example.com', 'Farmer'),
      ];

      authBloc.add(const LoginRequested('test@example.com', 'password123'));

      await expectLater(authBloc.stream, emitsInOrder(expected));
    });

    test('emits [AuthLoading, AuthError] when LoginRequested fails due to invalid email', () async {
      final expected = [
        AuthLoading(),
        const AuthError('Invalid email or password'),
      ];

      authBloc.add(const LoginRequested('invalid-email', 'password123'));

      await expectLater(authBloc.stream, emitsInOrder(expected));
    });
  });
}
