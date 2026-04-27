import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';

abstract class IAuthRepository {
  Stream<UserProfileEntity?> get authStateChanges;
  Future<UserProfileEntity> signInWithEmailAndPassword(
      String email, String password);
  Future<UserProfileEntity> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
  UserProfileEntity? get currentUser;
}
