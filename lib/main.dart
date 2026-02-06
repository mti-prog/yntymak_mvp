import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/splash/splash_screen.dart'; // Не забудь импортировать файл со сплэш-экраном

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yntymak MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
