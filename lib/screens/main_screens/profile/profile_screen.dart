import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/storage_service/storage_service.dart';
import '../../login_sign_up/login_screen.dart';
import '../add_post_screen/add_post_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.dark),
                  ),
                  IconButton(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Аватар
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppTheme.lightGreenBackGround, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=oleg'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Имя и телефон
              const Text(
                'Oleg Olegovich',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.dark),
              ),
              const SizedBox(height: 8),
              const Text(
                '+996 706 785 768',
                style: TextStyle(fontSize: 16, color: AppTheme.gray),
              ),
              const SizedBox(height: 40),

              // Секция My Services
              _buildSectionHeader('My Services'),
              _buildItemCard('Tutoring. I can help with math, science and school homework'),
              const SizedBox(height: 12),
              _buildItemCard('Pet sitting service & Dog walking.'),
              // КНОПКА ДЛЯ УСЛУГ
              _buildAddButton(AppTheme.dark, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(type: PostType.service),
                  ),
                );
              }),

              const SizedBox(height: 30),

              // Секция Help Requests
              _buildSectionHeader('Help Requests'),
              _buildItemCard('I need help setting up my computer and printer.'),
              // КНОПКА ДЛЯ ПОМОЩИ
              _buildAddButton(AppTheme.dark, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostScreen(type: PostType.help),
                  ),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearAll(); // Очищаем данные в SharedPreferences
              if (!context.mounted) return;
              // Переходим на логин и удаляем все предыдущие экраны из памяти
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Exit", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.dark),
        ),
      ),
    );
  }

  Widget _buildItemCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Добавил отступ между карточками
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Сделал карточки белыми как на скрине
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: AppTheme.dark),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.delete_outline, color: Colors.grey),
        ],
      ),
    );
  }

  // ОБНОВЛЕННАЯ КНОПКА С ПАРАМЕТРОМ onTap
  Widget _buildAddButton(Color color, VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('+ Add', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}