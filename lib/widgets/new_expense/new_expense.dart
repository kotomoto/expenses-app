import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense/amount_field.dart';
import 'package:expense_tracker/widgets/new_expense/date_picker_field.dart';
import 'package:expense_tracker/widgets/new_expense/title_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));

    Navigator.pop(context);
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  )
                ],
              ));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      var titleField = TitleWidget(titleController: _titleController);
      var amountField = AmountWidget(amountController: _amountController);

      // todo possible refactor to widget - pass function to widget
      var categoryField = DropdownButton(
          value: _selectedCategory,
          items: Category.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(
              () {
                _selectedCategory = value;
              },
            );
          });

      var dateField = DatePickerWidget(
        selectedDate: _selectedDate,
        onPress: _presentDatePicker,
      );

      var cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      );

      var saveButton = ElevatedButton(
        onPressed: _submitExpenseData,
        child: const Text('Save expense'),
      );

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: titleField,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: amountField,
                      )
                    ],
                  )
                else
                  titleField,
                if (width >= 600)
                  Row(
                    children: [
                      categoryField,
                      const SizedBox(width: 24),
                      Expanded(
                        child: dateField,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: amountField,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: dateField,
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      cancelButton,
                      saveButton,
                    ],
                  )
                else
                  Row(
                    children: [
                      categoryField,
                      const Spacer(),
                      cancelButton,
                      saveButton,
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
