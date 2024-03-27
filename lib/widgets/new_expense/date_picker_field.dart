import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    super.key,
    required DateTime? selectedDate,
    required void Function() onPress,
  }) : _onPressed = onPress, _selectedDate = selectedDate;

  final DateTime? _selectedDate;
  final void Function() _onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null ? 'No date selected' : formatter.format(_selectedDate),
        ),
        IconButton(
          onPressed: _onPressed,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }
}
