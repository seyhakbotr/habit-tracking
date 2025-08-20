import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry_habit.dart';

/// Temporary model class to store the time tracked for a habit.
class HabitDetails {
  HabitDetails({
    required this.name,
    required this.durationInHours,
  });
  final String name;
  double durationInHours;
}

/// Groups together all habits/entries on a given day.
class DailyHabitsDetails {
  DailyHabitsDetails({required this.date, required this.habitsDetails});
  final DateTime date;
  final List<HabitDetails> habitsDetails;

  double get duration => habitsDetails
      .map((habitDuration) => habitDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// Splits all entries into separate groups by date.
  static Map<DateTime, List<EntryHabit>> _entriesByDate(
      List<EntryHabit> entries) {
    final Map<DateTime, List<EntryHabit>> map = {};
    for (final entryHabit in entries) {
      final entryDayStart = DateTime(entryHabit.entry.start.year,
          entryHabit.entry.start.month, entryHabit.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryHabit];
      } else {
        map[entryDayStart]!.add(entryHabit);
      }
    }
    return map;
  }

  /// Maps an unordered list of EntryHabit into a list of DailyHabitsDetails with date information.
  static List<DailyHabitsDetails> all(List<EntryHabit> entries) {
    final byDate = _entriesByDate(entries);
    final List<DailyHabitsDetails> list = [];
    for (final pair in byDate.entries) {
      final date = pair.key;
      final entriesByDate = pair.value;
      final byHabit = _habitsDetails(entriesByDate);
      list.add(DailyHabitsDetails(date: date, habitsDetails: byHabit));
    }
    return list.toList();
  }

  /// Groups entries by habit.
  static List<HabitDetails> _habitsDetails(List<EntryHabit> entries) {
    final Map<String, HabitDetails> habitDuration = {};
    for (final entryHabit in entries) {
      final entry = entryHabit.entry;
      if (habitDuration[entry.habitId] == null) {
        habitDuration[entry.habitId] = HabitDetails(
          name: entryHabit.habit.name,
          durationInHours: entry.durationInHours,
        );
      } else {
        habitDuration[entry.habitId]!.durationInHours += entry.durationInHours;
      }
    }
    return habitDuration.values.toList();
  }
}
