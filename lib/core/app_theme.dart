import 'package:flutter/material.dart';
class AppTheme {
  static const Color primaryDark = Color(0xFF1B3344);
  static const Color bgLight = Color(0xFFF7FFF7);
  static const Color accentTeal = Color(0xFFD6EAE7);
  static const Color grayText = Color(0xFF7D7D7D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryDark,
      ),

      // Настройка текстовых полей (Input) как на макетах Login/Sign Up
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Сильное скругление
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
        hintStyle: const TextStyle(color: grayText, fontSize: 14),
        prefixIconColor: grayText,
      ),

      // Тема для кнопок
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // Кнопки на всю ширину
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // Настройка BottomNavigationBar (нижнее меню)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryDark,
        unselectedItemColor: grayText,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}