import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/daily_habits_details.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entries_list_tile_model.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry_habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/format.dart';

part 'entries_service.g.dart';

// TODO: Clean up this code a bit more
class EntriesService {
  EntriesService(
      {required this.habitsRepository, required this.entriesRepository});
  final HabitsRepository habitsRepository;
  final EntriesRepository entriesRepository;

  /// combine List<Habit>, List<Entry> into List<EntryHabit>
  Stream<List<EntryHabit>> _allEntriesStream(UserID uid) =>
      CombineLatestStream.combine2(
        entriesRepository.watchEntries(uid: uid),
        habitsRepository.watchHabits(uid: uid),
        _entriesHabitsCombiner,
      );

  static List<EntryHabit> _entriesHabitsCombiner(
      List<Entry> entries, List<Habit> habits) {
    return entries.map((entry) {
      final habit = habits.firstWhere((habit) => habit.id == entry.habitId);
      return EntryHabit(entry, habit);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> entriesTileModelStream(UserID uid) =>
      _allEntriesStream(uid).map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryHabit> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyHabitsDetails = DailyHabitsDetails.all(allEntries);

    // total duration across all habits
    final totalDuration = allDailyHabitsDetails
        .map((dateHabitsDuration) => dateHabitsDuration.duration)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: '',
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyHabitsDetails dailyHabitsDetails in allDailyHabitsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyHabitsDetails.date),
          middleText: '',
          trailingText: Format.hours(dailyHabitsDetails.duration),
        ),
        for (HabitDetails habitDuration in dailyHabitsDetails.habitsDetails)
          EntriesListTileModel(
            leadingText: habitDuration.name,
            middleText: '',
            trailingText: Format.hours(habitDuration.durationInHours),
          ),
      ]
    ];
  }
}

@riverpod
EntriesService entriesService(Ref ref) {
  return EntriesService(
    habitsRepository: ref.watch(habitsRepositoryProvider),
    entriesRepository: ref.watch(entriesRepositoryProvider),
  );
}

@riverpod
Stream<List<EntriesListTileModel>> entriesTileModelStream(Ref ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching entries');
  }
  final entriesService = ref.watch(entriesServiceProvider);
  return entriesService.entriesTileModelStream(user.uid);
}
