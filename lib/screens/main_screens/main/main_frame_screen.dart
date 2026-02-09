// 1. Импортируем все наши 4 экрана
import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Вместо body: _pages[_selectedIndex]
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.lightGreenBackGround,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.baseGreen, // Твой темно-синий
        unselectedItemColor: AppTheme.gray,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
  // Эта функция заставляет экран "проснуться" при переключении
  Widget _buildPage(int index) {
    switch (index) {// Каждый раз создаем свежий экран
      case 0: return const ServiceScreen();
      case 1: return const HelpRequestsScreen();
      case 2: return const FavoritesScreen();
      case 3: return const ProfileScreen();

      default: return const ServiceScreen();
    }
  }
}