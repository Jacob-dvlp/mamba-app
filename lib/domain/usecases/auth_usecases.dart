import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';

import '../repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _repo;
  SignInUseCase(this._repo);

  Future<UserProfileEntity> call(String email, String password) =>
      _repo.signInWithEmailAndPassword(email, password);
}

class SignUpUseCase {
  final IAuthRepository _repo;
  SignUpUseCase(this._repo);

  Future<UserProfileEntity> call(String email, String password) =>
      _repo.createUserWithEmailAndPassword(email, password);
}

class SignOutUseCase {
  final IAuthRepository _repo;
  SignOutUseCase(this._repo);
  Future<void> call() => _repo.signOut();
}

class GetAuthStateUseCase {
  final IAuthRepository _repo;
  GetAuthStateUseCase(this._repo);
  Stream<UserProfileEntity?> call() => _repo.authStateChanges;
}
