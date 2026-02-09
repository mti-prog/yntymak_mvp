import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppTheme.baseGreenBackGround,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: AppTheme.gray),
          hintText: "Search here...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}