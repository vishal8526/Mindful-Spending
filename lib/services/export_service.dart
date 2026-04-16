import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
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
    final csv = const ListToCsvConverter().convert(rows);
    await _shareBytes(
      fileName: 'transactions.csv',
      bytes: Uint8List.fromList(utf8.encode(csv)),
      mimeType: 'text/csv',
    );
  }

  // This function doesn't change
  Future<void> exportTransactionsToPdf(List<Transaction> transactions) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(text: 'Transaction Report', level: 0),
          pw.TableHelper.fromTextArray(
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
    await _shareBytes(
      fileName: 'transactions.pdf',
      bytes: bytes,
      mimeType: 'application/pdf',
    );
  }

  Future<void> _shareBytes({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: fileName, mimeType: mimeType)],
      text: 'My Transaction Report',
    );
  }
}
