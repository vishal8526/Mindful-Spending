import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget.dart';

class BudgetProvider with ChangeNotifier {
  final Box<Budget> _budgetBox = Hive.box<Budget>('budget');
  static const String _budgetKey = 'monthly_budget';

  BudgetProvider() {
    _budgetBox.listenable().addListener(notifyListeners);
  }

  double get monthlyBudget {
    return _budgetBox.get(_budgetKey)?.amount ?? 0.0;
  }

  Future<void> setBudget(double amount) async {
    final budget = Budget(amount: amount);
    await _budgetBox.put(_budgetKey, budget);
  }
}
