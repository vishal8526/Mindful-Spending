import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import '../widgets/category_icon.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categoryProvider.categories.length,
        itemBuilder: (ctx, index) {
          final category = categoryProvider.categories[index];
          return ListTile(
            leading: CategoryIcon(category: category),
            title: Text(category.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => categoryProvider.deleteCategory(category.id),
            ),
          );
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCategory = Category(
                  name: nameController.text,
                  iconCodePoint: Icons.label.codePoint, // Default icon
                  colorValue: Colors
                      .primaries[nameController.text.length %
                          Colors.primaries.length]
                      .toARGB32(), // Fun random color
                );
                Provider.of<CategoryProvider>(
                  context,
                  listen: false,
                ).addCategory(newCategory);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
