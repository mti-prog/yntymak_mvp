import 'package:yntymak_app_mvp/core/app_theme.dart';
import 'package:yntymak_app_mvp/providers/auth_provider/auth_provider.dart';
import 'package:yntymak_app_mvp/providers/locale_provider/locale_provider.dart';
import 'package:yntymak_app_mvp/providers/service_provider/service_provider.dart';
import 'package:yntymak_app_mvp/providers/translation_provider/translation_provider.dart';
import 'package:yntymak_app_mvp/providers/volunteer_provider/volunteer_provider.dart';
import 'package:yntymak_app_mvp/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => VolunteerProvider()),
        ChangeNotifierProvider(create: (_) => TranslationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
