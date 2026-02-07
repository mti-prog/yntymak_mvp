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
  int _currentIndex = 0;

// Вместо списка виджетов лучше возвращать виджет через функцию в body
// Это гарантирует, что при каждом setState в MainScreen, текущая страница будет перерисована
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // IndexedStack сохраняет состояние скролла, но требует обновления
        index: _currentIndex,
        children: const [

          ServicesScreen(),
          HelpRequestsScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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