import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAdd});
  final void Function(Expense expense) onAdd;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _didSelectCategory(Category? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _selectedCategory = value;
    });
  }

  void _submitTapped() {
    final enteredAmount = double.tryParse(_amountController.text);
    final enteredTitle = _titleController.text.trim();
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (enteredTitle.isEmpty || amountIsValid || _selectedDate == null) {
      _showPlatformBasedDialog();
      return;
    }
    final expense = Expense(
      title: enteredTitle,
      amount: enteredAmount,
      category: _selectedCategory,
      date: _selectedDate!,
    );
    widget.onAdd(expense);
    Navigator.pop(context);
  }

  void _showPlatformBasedDialog() {
    const title = 'Error';
    const message = 'Please make sure title, amount and data was entered.';
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text(title),
          content: const Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(title),
          content: const Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(context) {
    final keyboardTop = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardTop + 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : _selectedDate!.formatted,
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: _didSelectCategory,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitTapped,
                    child: const Text('Save Expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
