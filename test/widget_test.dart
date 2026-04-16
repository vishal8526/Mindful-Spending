import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:stressfree_spending/main.dart';
import 'package:stressfree_spending/models/budget.dart';
import 'package:stressfree_spending/models/category.dart';
import 'package:stressfree_spending/models/transaction.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('test_hive');

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(BudgetAdapter());
    }

    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox<Category>('categories');
    await Hive.openBox<Budget>('budget');
  });

  testWidgets('App boots and shows dashboard summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Monthly Budget Summary'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
