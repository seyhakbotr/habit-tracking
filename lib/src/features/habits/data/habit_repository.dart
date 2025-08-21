import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';

part 'habit_repository.g.dart';

class HabitsRepository {
  const HabitsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String habitPath(String uid, String habitId) =>
      'users/$uid/habits/$habitId';
  static String habitsPath(String uid) => 'users/$uid/habits';
  static String entriesPath(String uid) => EntriesRepository.entriesPath(uid);

  // create
  Future<void> addHabit(
          {required UserID uid,
          required String name,
          required int dailyGoal,
          DateTime? lastCompleted,
          int? streak,
          int? color}) =>
      _firestore.collection(habitsPath(uid)).add({
        'name': name,
        'dailyGoal': dailyGoal,
        'lastCompleted': lastCompleted,
        'streak': streak,
        'color': color,
      });

  // update
  Future<void> updateHabit({required UserID uid, required Habit habit}) =>
      _firestore.doc(habitPath(uid, habit.id)).update(habit.toMap());

  // delete
  Future<void> deleteHabit(
      {required UserID uid, required HabitID habitId}) async {
    // delete where entry.habitId == habit.habitId
    final entriesRef = _firestore.collection(entriesPath(uid));
    final entries = await entriesRef.get();
    for (final snapshot in entries.docs) {
      final entry = Entry.fromMap(snapshot.data(), snapshot.id);
      if (entry.habitId == habitId) {
        await snapshot.reference.delete();
      }
    }
    // delete habit
    final habitRef = _firestore.doc(habitPath(uid, habitId));
    await habitRef.delete();
  }

  Future<void> incrementHabitStreak({
    required UserID uid,
    required HabitID habitId,
  }) async {
    final habitDoc = _firestore.doc(habitPath(uid, habitId));

    await _firestore.runTransaction((transaction) async {
      final habitSnapshot = await transaction.get(habitDoc);

      if (habitSnapshot.exists) {
        final habitData = habitSnapshot.data() as Map<String, dynamic>;
        final currentStreak = habitData['streak'] ?? 0;
        final now = DateTime.now();

        transaction.update(habitDoc, {
          'streak': currentStreak + 1,
          'lastCompleted': now,
        });
      }
    });
  }

  // read
  Stream<Habit> watchHabit({required UserID uid, required HabitID habitId}) =>
      _firestore
          .doc(habitPath(uid, habitId))
          .withConverter<Habit>(
            fromFirestore: (snapshot, _) =>
                Habit.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (habit, _) => habit.toMap(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!);

  Stream<List<Habit>> watchHabits({required UserID uid}) =>
      queryHabits(uid: uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Habit> queryHabits({required UserID uid}) =>
      _firestore.collection(habitsPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Habit.fromMap(snapshot.data()!, snapshot.id),
            toFirestore: (habit, _) => habit.toMap(),
          );

  Future<List<Habit>> fetchHabits({required UserID uid}) async {
    final habits = await queryHabits(uid: uid).get();
    return habits.docs.map((doc) => doc.data()).toList();
  }
}

@Riverpod(keepAlive: true)
HabitsRepository habitsRepository(Ref ref) {
  return HabitsRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Habit> habitsQuery(Ref ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(habitsRepositoryProvider);
  return repository.queryHabits(uid: user.uid);
}

@riverpod
Stream<Habit> habitStream(Ref ref, HabitID habitId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(habitsRepositoryProvider);
  return repository.watchHabit(uid: user.uid, habitId: habitId);
}
