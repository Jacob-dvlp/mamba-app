import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String name;
  final int calories;
  final DateTime loggedAt;
  final String dailyLogId;

  const MealEntity({
    required this.id,
    required this.name,
    required this.calories,
    required this.loggedAt,
    required this.dailyLogId,
  });

  MealEntity copyWith({
    String? id,
    String? name,
    int? calories,
    DateTime? loggedAt,
    String? dailyLogId,
  }) {
    return MealEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      loggedAt: loggedAt ?? this.loggedAt,
      dailyLogId: dailyLogId ?? this.dailyLogId,
    );
  }

  @override
  List<Object?> get props => [id, name, calories, loggedAt, dailyLogId];
}
