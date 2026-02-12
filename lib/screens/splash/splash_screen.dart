import 'package:YntymakAppMVP/screens/main_screens/main/main_frame_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_theme.dart';
import '../../core/storage_service/storage_service.dart';
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
    _initApp(); // Запускаем одну общую логику
  }

  void _initApp() async {
    // 1. Пауза для показа логотипа
    await Future.delayed(const Duration(seconds: 3));

    // 2. Проверяем, видел ли пользователь Onboarding
    final prefs = await SharedPreferences.getInstance();
    final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

    if (!mounted) return;

    if (showOnboarding) {
      // Если ни разу не заходил — показываем онбординг
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      // Если онбординг уже видел — проверяем, залогинен ли он
      bool loggedIn = await StorageService.isLoggedIn();

      if (!mounted) return;

      if (loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainFrameScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.baseGreenBackGround,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
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
