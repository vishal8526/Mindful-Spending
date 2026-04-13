import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../models/transaction.dart';
import '../widgets/category_icon.dart';
import '../widgets/pie_chart_indicator.dart';
import '../services/export_service.dart'; // Make sure this import is here

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Helper method to show the export options dialog
  void _showExportDialog(BuildContext context) {
    // Get providers without listening to changes, as it's a one-time action
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final exportService = ExportService(categoryProvider: categoryProvider);

    // Show a simple dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Transactions'),
        content: const Text('Choose the format to export your data.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Export as CSV'),
            onPressed: () {
              exportService.exportTransactionsToCsv(
                transactionProvider.transactions,
              );
              Navigator.of(ctx).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Export as PDF'),
            onPressed: () {
              exportService.exportTransactionsToPdf(
                transactionProvider.transactions,
              );
              Navigator.of(ctx).pop(); // Close the dialog
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final double monthlyBudget = budgetProvider.monthlyBudget;
    final double totalSpending = transactionProvider.totalSpendingThisMonth;
    final double remainingBudget = monthlyBudget - totalSpending;
    final double spendingPercentage = monthlyBudget > 0
        ? (totalSpending / monthlyBudget).clamp(0, 1)
        : 0;

    final recentTransactions = transactionProvider.transactions
        .take(5)
        .toList();
    final expenseData = transactionProvider.expenseByCategoryThisMonth;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard (${DateFormat.yMMMM().format(DateTime.now())})"),
        // ADDED: Actions list for the export button
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () => _showExportDialog(context),
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Budget Summary Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Monthly Budget Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Budget: ₹${monthlyBudget.toStringAsFixed(2)}"),
                  Text(
                    "Spending: ₹${totalSpending.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.red),
                  ),
                  Text(
                    "Remaining: ₹${remainingBudget.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: spendingPercentage,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Pie Chart Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Spending by Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  expenseData.isEmpty
                      ? const Center(child: Text("No expenses this month."))
                      : Row(
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 40,
                                  sections: expenseData.entries.map((entry) {
                                    final category = categoryProvider
                                        .getCategoryById(entry.key);
                                    return PieChartSectionData(
                                      color: Color(
                                        category?.colorValue ??
                                            Colors.grey.value,
                                      ),
                                      value: entry.value,
                                      title:
                                          '₹${entry.value.toStringAsFixed(0)}',
                                      radius: 50,
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: expenseData.entries.map((entry) {
                                  final category = categoryProvider
                                      .getCategoryById(entry.key);
                                  return PieChartIndicator(
                                    color: Color(
                                      category?.colorValue ?? Colors.grey.value,
                                    ),
                                    text: category?.name ?? 'Unknown',
                                    isSquare: false,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recent Transactions
          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          recentTransactions.isEmpty
              ? const Text("No transactions yet.")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (ctx, index) {
                    final tx = recentTransactions[index];
                    final category = categoryProvider.getCategoryById(
                      tx.categoryId,
                    );
                    return Card(
                      elevation: 1,
                      child: ListTile(
                        leading: category != null
                            ? CategoryIcon(category: category)
                            : const CircleAvatar(),
                        title: Text(tx.title),
                        subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                        trailing: Text(
                          "${tx.type == TransactionType.expense ? '-' : '+'}₹${tx.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: tx.type == TransactionType.expense
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
