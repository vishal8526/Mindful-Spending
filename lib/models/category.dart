import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int iconCodePoint; // e.g., Icons.fastfood.codePoint

  @HiveField(3)
  int colorValue; // e.g., Colors.red.value

  Category({
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  }) : id = const Uuid().v4();
}
