import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryIcon extends StatelessWidget {
  final Category category;
  const CategoryIcon({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color(category.colorValue),
      child: Icon(
        IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
        color: Colors.white,
      ),
    );
  }
}
