// habit_entries_list_controller.g.dart
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart'; // Import the habit repository
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart'; // Import the habit domain

part 'habit_entries_list_controller.g.dart';

@riverpod
class HabitsEntriesListController extends _$HabitsEntriesListController {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  // Add the habitId parameter
  Future<void> deleteEntry(EntryID entryId, HabitID habitId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }

    // Get both repositories
    final entriesRepository = ref.read(entriesRepositoryProvider);
    final habitsRepository = ref.read(habitsRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Delete the entry
      await entriesRepository.deleteEntry(
          uid: currentUser.uid, entryId: entryId);

      // 2. Decrement the habit streak
      await habitsRepository.decrementHabitStreak(
          uid: currentUser.uid, habitId: habitId);
    });
  }
}
