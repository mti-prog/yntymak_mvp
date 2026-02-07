import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/main_screens/help/help_screen.dart';
import '../../../widgets/help_card.dart';
import '../../../widgets/service_card.dart';
import '../services/services_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Фильтруем услуги из первого списка
    final favServices = dummyServices.where((s) => s.isFavorite).toList();

    // 2. Фильтруем запросы помощи из ВТОРОГО списка (dummyHelps)
    // ВАЖНО: убедись, что dummyHelps импортирован в этот файл
    final favHelp = dummyHelps.where((h) => h.isFavorite).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3F1),
      body: SafeArea(
        child: ListView(
          children: [
            _buildMainHeader("Favourites"),

            // Секция Услуг
            if (favServices.isNotEmpty) ...[
              _buildMainHeader("Favorite Services"),
              ...favServices.map((s) => ServiceCard(
                service: s,
                onFavoritePressed: () => setState(() => s.isFavorite = false),
              )),
            ],

            // Секция Помощи (теперь берем из правильного списка)
            if (favHelp.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildMainHeader("Favorite Help Requests"),
              ...favHelp.map((h) => HelpCard(
                service: h,
                onFavoritePressed: () => setState(() => h.isFavorite = false),
              )),
            ],

            if (favServices.isEmpty && favHelp.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(child: Text("Здесь пока пусто")),
              ),
          ],
        ),
      ),
    );
  }

  // Метод переехал ВНУТРЬ класса _FavoritesScreenState
  Widget _buildMainHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B334B),
        ),
      ),
    );
  }
}