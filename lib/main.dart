import 'package:YntymakAppMVP/providers/auth_provider/auth_provider.dart';
import 'package:YntymakAppMVP/providers/service_provider/service_provider.dart';
import 'package:YntymakAppMVP/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ktvtnxmwdgrjuwtbntke.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0dnRueG13ZGdyanV3dGJudGtlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2NjQyNjQsImV4cCI6MjA4NzI0MDI2NH0.t7FlME8h3m0bqxUBfqt4_YDAVv9XHf35B-Oc_dbaW9s',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
