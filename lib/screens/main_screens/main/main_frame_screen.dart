// 1. Импортируем все наши 4 экрана
import 'package:flutter/material.dart';

import '../favorites/favorites_screen.dart';
import '../help/help_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';


class MainFrameScreen extends StatefulWidget {
  const MainFrameScreen({super.key});

  @override
  State<MainFrameScreen> createState() => _MainFrameScreenState();
}

class _MainFrameScreenState extends State<MainFrameScreen> {
  // 2. Переменная, которая хранит номер текущей вкладки (0, 1, 2 или 3)
  int _selectedIndex = 0;

  // 3. Список самих виджетов-экранов. Порядок важен!
  final List<Widget> _pages = [
    const ServicesScreen(),  // индекс 0
    const HelpRequestsScreen(),      // индекс 1
    const FavoritesScreen(), // индекс 2
    const ProfileScreen(),   // индекс 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. IndexedStack показывает экран из списка _pages под номером _selectedIndex
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // 5. Сама панель навигации внизу
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Подсвечивает нужную иконку
        onTap: (index) {
          // Когда ты тапаешь, мы меняем индекс и экран переключается
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1B334B), // Твой темно-синий
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}