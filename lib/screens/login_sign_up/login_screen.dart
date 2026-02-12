import 'package:YntymakAppMVP/screens/login_sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';


import '../../core/app_theme.dart';
import '../../core/storage_service/storage_service.dart';
import '../main_screens/main/main_frame_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Контроллеры для сбора данных
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Состояние для скрытия пароля
  bool _isPasswordHidden = true;

  // Функция для входа
  void _handleLogin() async{
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      // Показываем ошибку, если поля пустые
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Если всё ок — идем дальше
    await StorageService.setLoggedIn(true); // Сохраняем вход
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainFrameScreen()));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF1B334B);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome\nBack!",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, height: 1.1),
              ),
              const SizedBox(height: 60),

              // ПОЛЕ НОМЕРА
              _buildInputContainer(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(

                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: AppTheme.gray
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ПОЛЕ ПАРОЛЯ С ГЛАЗКОМ
              _buildInputContainer(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden, // Логика скрытия
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                        color: AppTheme.gray
                    ),
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    );
                  }, // Забыли пароль?
                  child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF4A708B))),
                ),
              ),

              const SizedBox(height: 25),

              // КНОПКА LOGIN
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _handleLogin, // Вызов логики
                  child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ),

              const SizedBox(height: 200),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Create An Account ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Sign Up Row...
            ],
          ),
        ),
      ),
    );
  }

  // Общий контейнер для стиля полей как на фото
  Widget _buildInputContainer({required Widget child}) {
    return Container(

      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: child,
    );
  }}