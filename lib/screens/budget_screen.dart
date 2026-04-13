import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final budget = Provider.of<BudgetProvider>(
      context,
      listen: false,
    ).monthlyBudget;
    if (budget > 0) {
      _controller.text = budget.toStringAsFixed(2);
    }
  }

  void _saveBudget() {
    final amount = double.tryParse(_controller.text);
    if (amount != null && amount > 0) {
      Provider.of<BudgetProvider>(context, listen: false).setBudget(amount);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Budget Saved!')));
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Monthly Budget Amount',
                prefixText: '₹',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBudget,
              child: const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
