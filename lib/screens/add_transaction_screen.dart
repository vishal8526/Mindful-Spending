import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;
  TransactionType _selectedType = TransactionType.expense;

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitData() {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a category.'),
        ),
      );
      return;
    }
    final newTx = Transaction(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      categoryId: _selectedCategory!.id,
      type: _selectedType,
    );
    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).addTransaction(newTx);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoryProvider>(context).categories;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter an amount' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                items: categories
                    .map(
                      (cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat.name)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (v) => v == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Expense'),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSelection) =>
                    setState(() => _selectedType = newSelection.first),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
