import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_screens/habits_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.habits),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.goNamed(AppRoute.addHabit.name),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen<AsyncValue>(
            habitsScreenControllerProvider,
            (_, state) => state.showAlertDialogOnError(context),
          );
          final habitQuery = ref.watch(habitsQueryProvider);
          return FirestoreListView<Habit>(
            query: habitQuery,
            emptyBuilder: (context) => const Center(child: Text('No data xd')),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loadingBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
            itemBuilder: (context, doc) {
              final habit = doc.data();
              return Dismissible(
                key: Key('habit-${habit.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => ref
                    .read(habitsScreenControllerProvider.notifier)
                    .deleteHabit(habit),
                child: HabitListTile(
                  habit: habit,
                  onTap: () => context.goNamed(
                    AppRoute.habit.name,
                    pathParameters: {'id': habit.id},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HabitListTile extends StatelessWidget {
  const HabitListTile({super.key, required this.habit, this.onTap});
  final Habit habit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = habit.color != null ? Color(habit.color!) : Colors.grey;
    final streak = habit.streak ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      child: ListTile(
        leading: Container(
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(habit.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Daily Goal: ${habit.dailyGoal} minutes'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (streak > 0)
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('$streak',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
