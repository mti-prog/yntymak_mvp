import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_theme.dart';
import '../board/onboarding_screen.dart';
import '../login_sign_up/login_screen.dart';
import '../main_screens/main/main_frame_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

    if (!mounted) return;

    if (showOnboarding) {
      // Первый раз — показываем онбординг
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      // Проверяем реальную сессию Supabase
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        // Сессия есть — сразу в приложение
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainFrameScreen()),
        );
      } else {
        // Сессии нет — на логин
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'YNTYMAK',
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
