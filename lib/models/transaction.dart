import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  double amount;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  String categoryId; // Link to Category
  @HiveField(5)
  TransactionType type;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
  }) : id = const Uuid().v4();
}
