import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider/auth_provider.dart';
import '../../providers/locale_provider/locale_provider.dart';
import '../../providers/service_provider/service_provider.dart';
import '../../providers/volunteer_provider/volunteer_provider.dart';
import '../main_screens/main/main_frame_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmHidden = true;
  String _accountType = 'user';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final pass = _passwordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirmPass.isEmpty) {
      _showError(AppLocalizations.tr(context, 'fill_all_fields'));
      return;
    }
    if (pass != confirmPass) {
      _showError(AppLocalizations.tr(context, 'passwords_no_match'));
      return;
    }
    if (pass.length < 6) {
      _showError(AppLocalizations.tr(context, 'password_min_length'));
      return;
    }

    final error = await context.read<AuthProvider>().signUp(
      email: email,
      password: pass,
      name: name,
      phone: phone,
      accountType: _accountType,
    );

    if (!mounted) return;
    if (error != null) {
      _showError(error);
    } else {
      context.read<ServiceProvider>().loadData();
      context.read<VolunteerProvider>().loadData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainFrameScreen()),
        (route) => false,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    context.watch<LocaleProvider>();
    const primaryDark = Color(0xFF1B334B);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.tr(context, 'create_account_title'),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 24),

              // Account Type Selector
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _accountType = 'user'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _accountType == 'user'
                              ? primaryDark
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _accountType == 'user'
                                ? primaryDark
                                : Colors.black12,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: _accountType == 'user'
                                  ? Colors.white
                                  : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.tr(context, 'user'),
                              style: TextStyle(
                                color: _accountType == 'user'
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _accountType = 'organization'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _accountType == 'organization'
                              ? const Color(0xFF7B1FA2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _accountType == 'organization'
                                ? const Color(0xFF7B1FA2)
                                : Colors.black12,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.business_outlined,
                              color: _accountType == 'organization'
                                  ? Colors.white
                                  : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.tr(context, 'organization'),
                              style: TextStyle(
                                color: _accountType == 'organization'
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Name
              _buildInputBox(
                controller: _nameController,
                hint: _accountType == 'organization'
                    ? AppLocalizations.tr(context, 'org_name')
                    : AppLocalizations.tr(context, 'your_name'),
                icon: _accountType == 'organization'
                    ? Icons.business
                    : Icons.person_outline,
              ),
              const SizedBox(height: 15),

              // Email
              _buildInputBox(
                controller: _emailController,
                hint: AppLocalizations.tr(context, 'email'),
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),

              // Phone
              _buildInputBox(
                controller: _phoneController,
                hint: AppLocalizations.tr(context, 'phone_number'),
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 15),

              // Password
              _buildInputBox(
                controller: _passwordController,
                hint: AppLocalizations.tr(context, 'password'),
                icon: Icons.lock_outline,
                isPassword: true,
                isHidden: _isPasswordHidden,
                onToggle: () =>
                    setState(() => _isPasswordHidden = !_isPasswordHidden),
              ),
              const SizedBox(height: 15),

              // Confirm Password
              _buildInputBox(
                controller: _confirmPasswordController,
                hint: AppLocalizations.tr(context, 'confirm_password'),
                icon: Icons.lock_outline,
                isPassword: true,
                isHidden: _isConfirmHidden,
                onToggle: () =>
                    setState(() => _isConfirmHidden = !_isConfirmHidden),
              ),
              const SizedBox(height: 25),

              Text(
                AppLocalizations.tr(context, 'agree_terms'),
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accountType == 'organization'
                        ? const Color(0xFF7B1FA2)
                        : primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleSignUp,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppLocalizations.tr(context, 'register'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.tr(context, 'already_have_account'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      AppLocalizations.tr(context, 'login'),
                      style: const TextStyle(
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
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
