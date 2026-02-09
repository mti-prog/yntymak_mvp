import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screens/main/main_frame_screen.dart';
import 'login_screen.dart'; // Путь к твоему логину

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF1B334B);
    const scaffoldBg = Color(0xFFF8FFF8);

    return Scaffold(
      backgroundColor: scaffoldBg,
      // AppBar только для заголовка "Sign Up" сверху, как на фото
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create an\naccount",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 40),

              // Поле Номера
              _buildInputBox(
                controller: _phoneController,
                hint: "Phone Number",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 15),

              // Поле Пароля
              _buildInputBox(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                isHidden: _isPasswordHidden,
                onToggle: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
              ),
              const SizedBox(height: 15),

              // Поле Подтверждения пароля
              _buildInputBox(
                controller: _confirmPasswordController,
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                isPassword: true,
                isHidden: _isConfirmHidden,
                onToggle: () => setState(() => _isConfirmHidden = !_isConfirmHidden),
              ),

              const SizedBox(height: 25),

              // Текст о публичной оферте
              const Text(
                "By clicking the Register button, you agree\nto the public offer",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // Кнопка Register
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    // 1. Получаем данные из полей
                    final phone = _phoneController.text.trim();
                    final pass = _passwordController.text.trim();
                    final confirmPass = _confirmPasswordController.text.trim();

                    // 2. Валидация (проверка)
                    if (phone.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
                      _showError("Please fill in all fields");
                      return;
                    }

                    if (pass != confirmPass) {
                      _showError("Passwords do not match!");
                      return;
                    }

                    if (pass.length < 6) {
                      _showError("Password must be at least 6 characters");
                      return;
                    }

                    // 3. Имитация сохранения пользователя (для MVP)
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('showOnboarding', false); // Онбординг больше не нужен
                    // Можно также сохранить флаг isLoggedIn, если ты его используешь

                    if (!mounted) return;

                    // 4. Успешный переход в главное приложение
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registration Successful!")),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainFrameScreen()),
                          (route) => false, // Очищаем стек экранов, чтобы нельзя было вернуться назад в регистрацию
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 200),

              // Переход на Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I Already Have an Account ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: primaryDark,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Универсальный виджет поля ввода
  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isHidden = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isHidden : false,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: onToggle,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
}}