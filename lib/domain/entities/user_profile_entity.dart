import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final int dailyCalorieGoal;
  final String? photoUrl;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.dailyCalorieGoal = 2000,
    this.photoUrl,
  });

  UserProfileEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? dailyCalorieGoal,
    String? photoUrl,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [uid, email, displayName, dailyCalorieGoal];
}
