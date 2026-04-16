import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  final Box<Category> _categoryBox = Hive.box<Category>('categories');
  List<Category> get categories => _categoryBox.values.toList();

  CategoryProvider() {
    _categoryBox.listenable().addListener(notifyListeners);
    _addDefaultCategories();
  }

  Future<void> _addDefaultCategories() async {
    if (_categoryBox.isEmpty) {
      final defaultCategories = [
        Category(
          name: 'Food',
          iconCodePoint: Icons.fastfood.codePoint,
          colorValue: Colors.orange.toARGB32(),
        ),
        Category(
          name: 'Transport',
          iconCodePoint: Icons.directions_car.codePoint,
          colorValue: Colors.blue.toARGB32(),
        ),
        Category(
          name: 'Shopping',
          iconCodePoint: Icons.shopping_bag.codePoint,
          colorValue: Colors.purple.toARGB32(),
        ),
        Category(
          name: 'Bills',
          iconCodePoint: Icons.receipt_long.codePoint,
          colorValue: Colors.red.toARGB32(),
        ),
        Category(
          name: 'Salary',
          iconCodePoint: Icons.account_balance_wallet.codePoint,
          colorValue: Colors.green.toARGB32(),
        ),
      ];
      for (var cat in defaultCategories) {
        await _categoryBox.put(cat.id, cat);
      }
    }
  }

  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  Category? getCategoryById(String id) {
    return _categoryBox.get(id);
  }
}
