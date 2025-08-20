import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/async_value_widget.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_entries_screen/habit_entries_list.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';

class HabitEntriesScreen extends ConsumerWidget {
  const HabitEntriesScreen({super.key, required this.habitId});
  final HabitID habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitStreamProvider(habitId));
    return ScaffoldAsyncValueWidget<Habit>(
      value: habitAsync,
      data: (habit) => HabitEntriesPageContents(habit: habit),
    );
  }
}

class HabitEntriesPageContents extends StatelessWidget {
  const HabitEntriesPageContents({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => context.goNamed(
              AppRoute.editHabit.name,
              pathParameters: {'id': habit.id},
              extra: habit,
            ),
          ),
        ],
      ),
      body: HabitEntriesList(habit: habit),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.goNamed(
          AppRoute.addEntry.name,
          pathParameters: {'id': habit.id},
          extra: habit,
        ),
      ),
    );
  }
}
