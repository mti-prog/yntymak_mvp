import 'package:flutter/material.dart';
class AppTheme {
  static const Color dark = Color(0xFF033059);

  static const Color baseGreenBackGround = Color(0xFFEEFDEC);
  static const Color baseGreen = Color(0xFF699D91);
  static const Color lightBlueBackground = Color(0xFFDBE9F0);
  static const Color lightGreenBackGround = Color(0xFFF8FDF4);
  static const Color gray = Color(0xFF706E70);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: baseGreenBackGround,
      colorScheme: ColorScheme.fromSeed(
        seedColor: dark,
        primary: dark,
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
        hintStyle: const TextStyle(color: gray, fontSize: 14),
        prefixIconColor: gray,
      ),

      // Тема для кнопок
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dark,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // Кнопки на всю ширину
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      // Настройка BottomNavigationBar (нижнее меню)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: dark,
        unselectedItemColor: gray,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}