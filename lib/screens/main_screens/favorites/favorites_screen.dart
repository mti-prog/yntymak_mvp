import 'package:flutter/material.dart';
import 'package:yntymak_mvp/screens/main_screens/help/help_screen.dart';

import '../../../models/service_model.dart';
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
    const primaryColor = Color(0xFF1B334B);
    const backgroundColor = Color(0xFFE8F3F1);

    // 1. Фильтруем избранные услуги (Offers)
    final favoriteServices = dummyServices
        .where((item) => item.isFavorite && item.type == ServiceType.offer)
        .toList();

    // 2. Фильтруем избранные запросы (Requests)
    final favoriteHelp = dummyHelps
        .where((item) => item.isFavorite && item.type == ServiceType.request)
        .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Favourites',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),

            if (favoriteServices.isEmpty && favoriteHelp.isEmpty)
              const Expanded(child: Center(child: Text('Здесь пока пусто')))
            else
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    // СЕКЦИЯ: ИЗБРАННЫЕ УСЛУГИ
                    if (favoriteServices.isNotEmpty) ...[
                      _buildSectionHeader('Favorite Services'),
                      ...favoriteServices.map((item) => ServiceCard(
                        service: item,
                        onFavoritePressed: () => setState(() => item.isFavorite = false),
                      )),
                    ],

                    const SizedBox(height: 20),

                    // СЕКЦИЯ: ИЗБРАННЫЕ ЗАПРОСЫ
                    if (favoriteHelp.isNotEmpty) ...[
                      _buildSectionHeader('Favorite Help Requests'),
                      ...favoriteHelp.map((item) => HelpCard(
                        service: item,
                        onFavoritePressed: () => setState(() => item.isFavorite = false),
                      )),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный виджет для заголовка секции
  Widget _buildSectionHeader(String title) {
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