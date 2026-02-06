import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/login_sign_up/sign_up_screen.dart';

import '../main_screens/main/main_frame_screen.dart';
 // Импортируем экран регистрации

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Ключ для управления формой
  final _formKey = GlobalKey<FormState>();

  // Контроллеры для получения текста из полей
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Логика нажатия на кнопку входа
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Если валидация прошла успешно
      print("Email: ${_emailController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Входим в систему...')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainFrameScreen()),
            (route) => false, // Это удаляет экран логина из памяти, чтобы нельзя было вернуться назад
      );
    }
  }
  @override
  void initState() {
    super.initState();
    // Слушаем изменения в полях, чтобы обновлять кнопку
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {}); // Перерисовываем экран при каждом символе
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Оборачиваем в SingleChildScrollView, чтобы не было Overflow при открытии клавиатуры
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey, // Привязываем ключ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 32),

                // Поле Email с валидацией
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Введите корректный Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле Пароль
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Скрывает символы
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),

                // Кнопка Forgot Password
                Align(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?', style: TextStyle(color: Colors.grey)),
                  )
                ),
                const SizedBox(height: 24),

                // Кнопка входа
                ElevatedButton(
                  // Если поля пустые, onPressed будет null (кнопка станет серой/неактивной)
                  onPressed: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                      ? _submit
                      : null,
                  child: const Text('Login'),
                ),

                const SizedBox(height: 16),

                // Переход на регистрацию
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Обычный переход, чтобы можно было вернуться
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}