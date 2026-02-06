import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/main_screens/main/main_frame_screen.dart';// Импортируем наш каркас навигации

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // 1. Создаем ключ
    final formKey = GlobalKey<FormState>();


    return Scaffold(
      // AppBar автоматически добавит стрелочку "Назад"
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Form(child:
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign Up', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 32),

            // Поле Имя
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Поле Email
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Поле Пароль
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 32),

            // Кнопка регистрации
            ElevatedButton(
              onPressed: () {
                // 1. Проверяем, что форма заполнена корректно
                if (formKey.currentState!.validate()) {
                  // 2. Только если всё ок, пускаем в MainScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainFrameScreen()),
                        (route) => false,
                  );
                } else {
                  // Если поля пустые, Flutter сам покажет красный текст ошибки под полями
                  print("Форма не заполнена!");
                }
              },
              child: const Text('Create Account'),
            ),

            const SizedBox(height: 16),

            // Ссылка на логин
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pop(context), // Просто возвращаемся назад
                  child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}