import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/edit_habit_screen/habit_submit_exception.dart';

part 'edit_habit_screen_controller.g.dart';

@riverpod
class EditHabitScreenController extends _$EditHabitScreenController {
  @override
  FutureOr<void> build() {
    //
  }

  Future<bool> submit({
    HabitID? habitId,
    Habit? oldHabit,
    required String name,
    required int dailyGoal,
    DateTime? lastCompleted,
    int? streak,
    int? color,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    // Set loading state
    state = const AsyncLoading().copyWithPrevious(state);
    // Check if name is already in use
    final repository = ref.read(habitsRepositoryProvider);
    final habits = await repository.fetchHabits(uid: currentUser.uid);
    final allLowerCaseNames =
        habits.map((habit) => habit.name.toLowerCase()).toList();
    // It's ok to use the same name as the old habit
    if (oldHabit != null) {
      allLowerCaseNames.remove(oldHabit.name.toLowerCase());
    }
    // Check if name is already used
    if (allLowerCaseNames.contains(name.toLowerCase())) {
      state = AsyncError(HabitSubmitException(), StackTrace.current);
      return false;
    } else {
      try {
        if (habitId != null) {
          // If we are editing, we create a new Habit object
          // with all properties to update the record.
          final habit = Habit(
            id: habitId,
            name: name,
            dailyGoal: dailyGoal,
            lastCompleted: lastCompleted,
            streak: streak ?? 0,
            color: color,
          );
          await repository.updateHabit(uid: currentUser.uid, habit: habit);
        } else {
          // If we are adding a new habit, we use the new parameters.
          await repository.addHabit(
            uid: currentUser.uid,
            name: name,
            dailyGoal: dailyGoal,
            lastCompleted: lastCompleted,
            streak: streak ?? 0,
            color: color,
          );
        }
        state = const AsyncData(null);
        return true;
      } catch (e, st) {
        state = AsyncError(e, st);
        return false;
      }
    }
  }
}
