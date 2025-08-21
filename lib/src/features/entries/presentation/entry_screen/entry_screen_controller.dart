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
    final repository = ref.read(entriesRepositoryProvider);
    state = const AsyncLoading();
    if (entryId == null) {
      state = await AsyncValue.guard(() => repository.addEntry(
            uid: currentUser.uid,
            habitId: habitId,
            start: start,
            end: end,
            comment: comment,
          ));
    } else {
      final entry = Entry(
        id: entryId,
        habitId: habitId,
        start: start,
        end: end,
        comment: comment,
      );
      state = await AsyncValue.guard(
          () => repository.updateEntry(uid: currentUser.uid, entry: entry));
    }
    return state.hasError == false;
  }

  Future<bool> incrementStreak(HabitID habitId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }

    final repository = ref.read(habitsRepositoryProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => repository.incrementHabitStreak(
          uid: currentUser.uid,
          habitId: habitId,
        ));

    return state.hasError == false;
  }
}
