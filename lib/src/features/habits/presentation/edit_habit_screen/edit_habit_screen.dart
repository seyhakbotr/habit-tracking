import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/responsive_center.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/breakpoints.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/presentation/edit_habit_screen/edit_habit_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  const EditHabitScreen({super.key, this.habitId, this.habit});
  final HabitID? habitId;
  final Habit? habit;

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends ConsumerState<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _dailyGoal;
  DateTime? _lastCompleted;
  int? _streak;
  int? _color;
  final TextEditingController _lastCompletedController =
      TextEditingController();

  // A list of sample colors for the picker
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _name = widget.habit?.name;
      _dailyGoal = widget.habit?.dailyGoal;
      _lastCompleted = widget.habit?.lastCompleted;
      _streak = widget.habit?.streak;
      _color = widget.habit?.color;
      if (_lastCompleted != null) {
        _lastCompletedController.text =
            DateFormat('yyyy-MM-dd').format(_lastCompleted!);
      }
    }
  }

  @override
  void dispose() {
    _lastCompletedController.dispose();
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final success =
          await ref.read(editHabitScreenControllerProvider.notifier).submit(
                habitId: widget.habitId,
                oldHabit: widget.habit,
                name: _name ?? '',
                dailyGoal: _dailyGoal ?? 0,
                lastCompleted: _lastCompleted,
                streak: _streak,
                color: _color,
              );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastCompleted ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _lastCompleted) {
      setState(() {
        _lastCompleted = picked;
        _lastCompletedController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectColor() async {
    final Color? pickedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        _color = pickedColor.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editHabitScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editHabitScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'New Habit' : 'Edit Habit'),
        actions: <Widget>[
          TextButton(
            onPressed: state.isLoading ? null : _submit,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Habit name'),
        keyboardAppearance: Brightness.light,
        initialValue: _name,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Daily Goal (minutes)'),
        keyboardAppearance: Brightness.light,
        initialValue: _dailyGoal != null ? '$_dailyGoal' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _dailyGoal = int.tryParse(value ?? '') ?? 0,
      ),
      TextFormField(
        controller: _lastCompletedController,
        decoration: InputDecoration(
          labelText: 'Last Completed',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        onSaved: (value) {
          // The date is already saved to _lastCompleted via the picker
        },
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Streak'),
        keyboardAppearance: Brightness.light,
        initialValue: _streak != null ? '$_streak' : null,
        keyboardType: TextInputType.number,
        onSaved: (value) => _streak = int.tryParse(value ?? '') ?? 0,
      ),
      ListTile(
        title: const Text('Color'),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _color != null ? Color(_color!) : Colors.transparent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onTap: _selectColor,
      ),
    ];
  }
}
