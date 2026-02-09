import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_theme.dart';
import '../board/onboarding_screen.dart';
import '../login_sign_up/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // 1. Ждем 2-3 секунды для красоты
    await Future.delayed(const Duration(seconds: 3));

    // 2. Проверяем настройки
    final prefs = await SharedPreferences.getInstance();
    final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

    if (!mounted) return;

    // 3. Переходим на нужный экран
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => showOnboarding
            ? const OnboardingScreen()
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.baseGreenBackGround, // Твой фирменный цвет
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Твой логотип или иконк
            Image.asset(
              'assets/images/logo.png', // Укажи здесь точный путь к файлу
              width: 150, // Настрой размер под себя
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "YNTYMAK",
              style: TextStyle(
                color: AppTheme.dark,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}