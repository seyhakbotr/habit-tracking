import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_entries_screen/entry_list_item.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/habit_entries_screen/habit_entries_list_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class HabitEntriesList extends ConsumerWidget {
  const HabitEntriesList({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      habitsEntriesListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final habitEntriesQuery = ref.watch(habitEntriesQueryProvider(habit.id));
    return FirestoreListView<Entry>(
      query: habitEntriesQuery,
      itemBuilder: (context, doc) {
        final entry = doc.data();
        return DismissibleEntryHabitListItem(
          dismissibleKey: Key('entry-${entry.id}'),
          entry: entry,
          habit: habit,
          onDismissed: () => ref
              .read(habitsEntriesListControllerProvider.notifier)
              .deleteEntry(entry.id, habit.id),
          onTap: () => context.goNamed(
            AppRoute.entry.name,
            pathParameters: {'id': habit.id, 'eid': entry.id},
            extra: entry,
          ),
        );
      },
    );
  }
}
