import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Логика перехода через 3 секунды
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Используем pushReplacement, чтобы нельзя было вернуться назад
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF4F9F1), // Твой цвет из задания
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.jpg'),
          width: 150, // Настрой размер под свой логотип
        ),
      ),
    );
  }
}