import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 3)
class Budget extends HiveObject {
  @HiveField(0)
  double amount;

  Budget({required this.amount});
}
