import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:mamba_fast_tracker/core/errors/failures.dart';
import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';

import '../../core/utils/string_constants_utils.dart';

class FirebaseAuthDataSource implements IAuthDataSource {
  final FirebaseAuth firebaseAuth;
  FirebaseAuthDataSource({required this.firebaseAuth});
  @override
  Future<UserProfileEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toEntity(credential.user!);
    } on FirebaseAuthException catch (e, stack) {
      FirebaseCrashlytics.instance
          .recordError(e, stack, fatal: false, reason: e.message);

      throw AuthFailure(mapFirebaseError(e.code));
    }
  }

  @override
  Future<UserProfileEntity> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toEntity(credential.user!);
    } on FirebaseAuthException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        fatal: false,
        reason: e.message,
      );

      throw AuthFailure(mapFirebaseError(e.code));
    }
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();

  @override
  Stream<UserProfileEntity?> get authStateChanges => firebaseAuth
      .authStateChanges()
      .map((u) => u != null ? _toEntity(u) : null);

  UserProfileEntity _toEntity(User user) => UserProfileEntity(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );

  @override
  UserProfileEntity? get currentUser => firebaseAuth.currentUser != null
      ? _toEntity(firebaseAuth.currentUser!)
      : null;
}

abstract interface class IAuthDataSource {
  Stream<UserProfileEntity?> get authStateChanges;
  Future<UserProfileEntity> signInWithEmailAndPassword(
      String email, String password);
  Future<UserProfileEntity> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
  UserProfileEntity? get currentUser;
}
