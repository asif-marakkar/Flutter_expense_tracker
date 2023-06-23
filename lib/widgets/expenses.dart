import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  void _showAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (cxt) => NewExpense(
        onAdd: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(index, expense);
            });
          },
        ),
        content: const Text('Expense removed'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = _registeredExpenses.isNotEmpty
        ? ExpensesList(
            expenses: _registeredExpenses,
            onRemove: _removeExpense,
          )
        : const Center(
            child: Text(
              'No expenses found. Start adding some!',
            ),
          );
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _showAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
