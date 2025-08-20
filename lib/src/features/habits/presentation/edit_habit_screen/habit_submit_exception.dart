class HabitSubmitException {
  String get title => 'Name already used';
  String get description => 'Please choose a different habit name';

  @override
  String toString() {
    return '$title. $description.';
  }
}
