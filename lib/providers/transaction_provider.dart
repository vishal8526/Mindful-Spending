import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import 'dart:collection';

class TransactionProvider with ChangeNotifier {
  final Box<Transaction> _transactionBox = Hive.box<Transaction>(
    'transactions',
  );

  List<Transaction> get transactions =>
      _transactionBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  TransactionProvider() {
    _transactionBox.listenable().addListener(notifyListeners);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  double get totalSpendingThisMonth {
    final now = DateTime.now();
    return transactions
        .where(
          (tx) =>
              tx.type == TransactionType.expense &&
              tx.date.month == now.month &&
              tx.date.year == now.year,
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // For Pie Chart
  Map<String, double> get expenseByCategoryThisMonth {
    final Map<String, double> data = {};
    final now = DateTime.now();
    final monthlyExpenses = transactions.where(
      (tx) =>
          tx.type == TransactionType.expense &&
          tx.date.month == now.month &&
          tx.date.year == now.year,
    );

    for (var tx in monthlyExpenses) {
      data.update(
        tx.categoryId,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    return data;
  }
}
