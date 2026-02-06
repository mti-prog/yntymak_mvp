import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yntymak_mvp/screens/board/onboarding_screen.dart';
import 'package:yntymak_mvp/screens/login_sign_up/login_screen.dart';

void main() async {
  // 1. Обязательно инициализируем движок Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Читаем настройки из памяти
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: ,
      // 3. Решаем, куда идти: на Onboarding или сразу на Login
      // (Splash все равно может быть первым, если ты хочешь,
      // но логику "куда потом" передаем в него)
      home: showOnboarding ? const OnboardingScreen() : const LoginScreen(),
    );
  }
}