import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';

part 'entry_screen_controller.g.dart';

@riverpod
class EntryScreenController extends _$EntryScreenController {
  @override
  FutureOr<void> build() {
    // ok to leave this empty if the return type is FutureOr<void>
  }

  Future<bool> submit({
    EntryID? entryId,
    required HabitID habitId,
    required DateTime start,
    required DateTime end,
    required String comment,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final entriesRepository = ref.read(entriesRepositoryProvider);
    final habitsRepository = ref.read(habitsRepositoryProvider);

    state = const AsyncLoading();

    try {
      if (entryId == null) {
        // Step 1: Add the new entry to Firestore
        await entriesRepository.addEntry(
          uid: currentUser.uid,
          habitId: habitId,
          start: start,
          end: end,
          comment: comment,
        );

        // Step 2: After the entry is successfully added, increment the habit streak
        await habitsRepository.incrementHabitStreak(
          uid: currentUser.uid,
          habitId: habitId,
        );
      } else {
        final entry = Entry(
          id: entryId,
          habitId: habitId,
          start: start,
          end: end,
          comment: comment,
        );
        await entriesRepository.updateEntry(uid: currentUser.uid, entry: entry);
      }
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteEntry({
    required EntryID entryId,
    required HabitID habitId,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final entriesRepository = ref.read(entriesRepositoryProvider);
    final habitsRepository = ref.read(habitsRepositoryProvider);

    state = const AsyncLoading();

    try {
      // Step 1: Delete the entry from Firestore
      await entriesRepository.deleteEntry(
        uid: currentUser.uid,
        entryId: entryId,
      );

      // Step 2: After the entry is successfully deleted, decrement the habit streak
      await habitsRepository.decrementHabitStreak(
        uid: currentUser.uid,
        habitId: habitId,
      );

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
