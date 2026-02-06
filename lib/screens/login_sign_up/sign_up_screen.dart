import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/main_screens/main/main_frame_screen.dart';// Импортируем наш каркас навигации

class SignUpScreen extends StatefulWidget { // Меняем на StatefulWidget
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ВЫНОСИМ СЮДА (вне метода build)
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    // Хорошим тоном считается удалять контроллеры, когда экран закрывается
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey, // Привязываем наш постоянный ключ
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 32),

              // Поле Имя
              TextFormField(
                controller: _nameController, // Добавляем контроллер
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),

              // Поле Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) return "Enter valid email";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле Пароль
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) => value!.length < 6 ? "Min 6 symbols" : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  // Теперь currentState будет работать правильно
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainFrameScreen()),
                          (route) => false,
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}