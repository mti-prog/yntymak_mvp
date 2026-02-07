import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1B334B); // Твой основной темно-синий цвет

    return Scaffold(
      backgroundColor: const Color(0xFFEDF5F4), // Светло-бирюзовый фон из дизайна
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Profile',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 30),

              // Аватар
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                '+996 706 785 768',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Секция My Services
              _buildSectionHeader('My Services'),
              _buildItemCard('Tutoring. I can help with math, science and school homework'),
              const SizedBox(height: 12),
              _buildItemCard('Pet sitting service & Dog walking.'),
              _buildAddButton(primaryColor),

              const SizedBox(height: 30),

              // Секция Help Requests
              _buildSectionHeader('Help Requests'),
              _buildItemCard('I need help setting up my computer and printer.'),
              _buildAddButton(primaryColor),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Заголовок секции
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B334B)),
        ),
      ),
    );
  }

  // Карточка услуги/запроса
  Widget _buildItemCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.delete_outline, color: Colors.grey[400]),
        ],
      ),
    );
  }

  // Кнопка + Add
  Widget _buildAddButton(Color color) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ElevatedButton(
          onPressed: () {},
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