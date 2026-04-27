import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mamba_fast_tracker/presentation/auth/cubit/auth_cubit.dart';

import '../../../helper/healper_test.dart';

void main() {
  late MockSignInUseCase mockSignIn;
  late MockSignUpUseCase mockSignUp;
  late MockSignOutUseCase mockSignOut;
  late MockGetAuthStateUseCase mockGetAuthState;

  late StreamController<UserProfileEntity?> authStreamCtrl;

  setUp(() {
    mockSignIn = MockSignInUseCase();
    mockSignUp = MockSignUpUseCase();
    mockSignOut = MockSignOutUseCase();
    mockGetAuthState = MockGetAuthStateUseCase();
    authStreamCtrl = StreamController<UserProfileEntity?>.broadcast();

    when(() => mockGetAuthState()).thenAnswer((_) => authStreamCtrl.stream);
  });

  tearDown(() {
    authStreamCtrl.close();
  });

  AuthCubit _buildCubit() => AuthCubit(
        signIn: mockSignIn,
        signUp: mockSignUp,
        signOut: mockSignOut,
        getAuthState: mockGetAuthState,
      );
  group('initial state', () {
    test('starts as AuthInitial', () {
      final cubit = _buildCubit();
      expect(cubit.state, isA<AuthInitial>());
      cubit.close();
    });

    test('emits AuthAuthenticated when stream emits a user', () async {
      final user = Fixtures.user();
      final cubit = _buildCubit();

      authStreamCtrl.add(user);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<AuthAuthenticated>());
      expect((cubit.state as AuthAuthenticated).user, user);
      cubit.close();
    });

    test('emits AuthUnauthenticated when stream emits null', () async {
      final cubit = _buildCubit();

      authStreamCtrl.add(null);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isA<AuthUnauthenticated>());
      cubit.close();
    });
  });

  group('signIn', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      setUp: () {
        when(() => mockSignIn(any(), any()))
            .thenAnswer((_) async => Fixtures.user());
      },
      build: _buildCubit,
      act: (cubit) => cubit.signIn('test@mamba.com', 'password123'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      setUp: () {
        when(() => mockSignIn(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.signIn('test@mamba.com', 'wrong'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'AuthAuthenticated contains correct user data',
      setUp: () {
        when(() => mockSignIn(any(), any()))
            .thenAnswer((_) async => Fixtures.user(email: 'hello@mamba.com'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.signIn('hello@mamba.com', 'pass'),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthState>(
            (s) => s is AuthAuthenticated && s.user.email == 'hello@mamba.com'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'maps wrong-password error to human message',
      setUp: () {
        when(() => mockSignIn(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.signIn('a@b.com', 'x'),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthState>(
            (s) => s is AuthError && s.message == 'Senha incorreta.'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'maps user-not-found error to human message',
      setUp: () {
        when(() => mockSignIn(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.signIn('nobody@x.com', 'pass'),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthState>(
            (s) => s is AuthError && s.message == 'Usuário não encontrado.'),
      ],
    );
  });

  group('signUp', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      setUp: () {
        when(() => mockSignUp(any(), any()))
            .thenAnswer((_) async => Fixtures.user());
      },
      build: _buildCubit,
      act: (cubit) => cubit.signUp('new@mamba.com', 'pass123'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'maps email-already-in-use to human message',
      setUp: () {
        when(() => mockSignUp(any(), any()))
            .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));
      },
      build: _buildCubit,
      act: (cubit) => cubit.signUp('exists@mamba.com', 'pass'),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthState>(
            (s) => s is AuthError && s.message == 'E-mail já cadastrado.'),
      ],
    );
  });

  // ─── signOut ──────────────────────────────────────────────
  group('signOut', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated after sign out',
      setUp: () {
        when(() => mockSignOut()).thenAnswer((_) async {});
      },
      build: _buildCubit,
      act: (cubit) => cubit.signOut(),
      expect: () => [isA<AuthUnauthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'calls SignOutUseCase exactly once',
      setUp: () {
        when(() => mockSignOut()).thenAnswer((_) async {});
      },
      build: _buildCubit,
      act: (cubit) => cubit.signOut(),
      verify: (_) {
        verify(() => mockSignOut()).called(1);
      },
    );
  });
}
