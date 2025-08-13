import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef HabitID = String;

@immutable
class Habit extends Equatable {
  const Habit({
    required this.id,
    required this.name,
    required this.dailyGoal,
    this.lastCompleted, // The date the habit was last checked off
    this.streak = 0, // The current streak of consecutive completions
    this.color, // A color for the habit in the UI
  });

  final HabitID id;
  final String name;
  final int dailyGoal;
  final DateTime? lastCompleted;
  final int streak;
  final int? color;

  @override
  List<Object?> get props =>
      [id, name, dailyGoal, lastCompleted, streak, color];

  @override
  bool get stringify => true;

  factory Habit.fromMap(Map<String, dynamic> data, String id) {
    final name = data['name'] as String;
    final dailyGoal = data['dailyGoal'] as int;
    final lastCompleted = (data['lastCompleted'] as Timestamp?)?.toDate();
    final streak = data['streak'] as int? ?? 0;
    final color = data['color'] as int?;

    return Habit(
      id: id,
      name: name,
      dailyGoal: dailyGoal,
      lastCompleted: lastCompleted,
      streak: streak,
      color: color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dailyGoal': dailyGoal,
      'lastCompleted': lastCompleted,
      'streak': streak,
      'color': color,
    };
  }
}
