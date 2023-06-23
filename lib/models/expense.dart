import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  leisure,
  work,
}

extension CategoryExtension on Category {
  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.lunch_dining;
      case Category.travel:
        return Icons.flight_takeoff;
      case Category.leisure:
        return Icons.movie;
      case Category.work:
        return Icons.work;
    }
  }
}

extension DateExtension on DateTime {
  String get formatted => formatter.format(this);
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.byCategory(this.category, List<Expense> allExpenses)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
