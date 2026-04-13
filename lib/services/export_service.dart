import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart'; // Use this package

import '../models/transaction.dart';
import '../providers/category_provider.dart';

class ExportService {
  final CategoryProvider categoryProvider;

  ExportService({required this.categoryProvider});

  // This function doesn't change
  Future<void> exportTransactionsToCsv(List<Transaction> transactions) async {
    List<List<dynamic>> rows = [];
    rows.add(['Date', 'Title', 'Category', 'Amount', 'Type']);
    for (var tx in transactions) {
      final category = categoryProvider.getCategoryById(tx.categoryId);
      rows.add([
        DateFormat('yyyy-MM-dd').format(tx.date),
        tx.title,
        category?.name ?? 'N/A',
        tx.amount.toStringAsFixed(2),
        tx.type.name,
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    // We call the new save and share method
    await _saveAndShareFile('transactions.csv', csv);
  }

  // This function doesn't change
  Future<void> exportTransactionsToPdf(List<Transaction> transactions) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(text: 'Transaction Report', level: 0),
          pw.Table.fromTextArray(
            headers: ['Date', 'Title', 'Category', 'Amount', 'Type'],
            data: transactions.map((tx) {
              final category = categoryProvider.getCategoryById(tx.categoryId);
              final isExpense = tx.type == TransactionType.expense;
              return [
                DateFormat('yyyy-MM-dd').format(tx.date),
                tx.title,
                category?.name ?? 'N/A',
                '${isExpense ? '-' : '+'}₹${tx.amount.toStringAsFixed(2)}',
                tx.type.name,
              ];
            }).toList(),
          ),
        ],
      ),
    );
    final bytes = await pdf.save();
    // We call the new save and share method
    await _saveAndShareFile('transactions.pdf', bytes);
  }

  /// Saves the file to a temporary directory and then opens the native share dialog.
  Future<void> _saveAndShareFile(String fileName, dynamic data) async {
    // 1. Save the file to a temporary private directory
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);

    if (data is String) {
      await file.writeAsString(data);
    } else if (data is List<int>) {
      await file.writeAsBytes(data);
    }

    // 2. Use share_plus to open the share dialog
    // The user can now choose to save it to their "Downloads" folder or any other app.
    await Share.shareXFiles([XFile(path)], text: 'My Transaction Report');
  }
}
