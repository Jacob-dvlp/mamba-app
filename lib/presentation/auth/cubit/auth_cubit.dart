import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';
import '../../../../domain/usecases/auth_usecases.dart';
import '../../../core/errors/failures.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  final GetAuthStateUseCase _getAuthState;

  StreamSubscription<UserProfileEntity?>? _authSub;

  AuthCubit({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required SignOutUseCase signOut,
    required GetAuthStateUseCase getAuthState,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _getAuthState = getAuthState,
        super(const AuthInitial()) {
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _authSub = _getAuthState().listen((user) {
      if (state is AuthLoading || state is AuthError) return;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthLoading());
    try {
      await _signIn(email, password);
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
      await Future.delayed(Duration.zero);
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthError('Erro inesperado. Tente novamente.'));
      await Future.delayed(Duration.zero);
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _signUp(email, password);
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthError(e.message));
      await Future.delayed(Duration.zero);
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthError('Erro inesperado. Tente novamente.'));
      await Future.delayed(Duration.zero);
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    await _signOut();
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
