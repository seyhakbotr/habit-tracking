import 'package:equatable/equatable.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';

class EntryHabit extends Equatable {
  const EntryHabit(this.entry, this.habit);

  final Entry entry;
  final Habit habit;

  @override
  List<Object?> get props => [entry, habit];

  @override
  bool? get stringify => true;
}
