import 'package:mamba_fast_tracker/domain/entities/user_profile_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final IAuthDataSource _dataSource;

  FirebaseAuthRepository({required IAuthDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<UserProfileEntity?> get authStateChanges =>
      _dataSource.authStateChanges;

  @override
  Future<UserProfileEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) =>
      _dataSource.signInWithEmailAndPassword(email, password);

  @override
  Future<UserProfileEntity> createUserWithEmailAndPassword(
    String email,
    String password,
  ) =>
      _dataSource.createUserWithEmailAndPassword(email, password);

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  UserProfileEntity? get currentUser => _dataSource.currentUser;
}
