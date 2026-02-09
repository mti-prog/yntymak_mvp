import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../models/service_model.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/help_card.dart';
import '../../../widgets/service_card.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();
    final favServices = provider.favorites.where((s) => s.type == ServiceType.offer).toList();
    final favHelp = provider.favorites.where((s) => s.type == ServiceType.request).toList();

    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: ListView(
          children: [
            _buildMainHeader("Favourites"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.lightGreenBackGround,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a help requests...',
                  prefixIcon: Icon(Icons.search, color: AppTheme.gray),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            if (favServices.isNotEmpty) ...[
              _buildMainHeader("Favorite Services"),
              ...favServices.map((s) => ServiceCard(
                service: s,
                onFavoritePressed: () => provider.toggleFavorite(s.id),
              )),
            ],
            if (favHelp.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildMainHeader("Favorite Help Requests"),
              ...favHelp.map((h) => HelpCard(
                service: h,
                onFavoritePressed: () => provider.toggleFavorite(h.id),
              )),
            ],
            if (provider.favorites.isEmpty)
              const Center(child: Text("Здесь пока пусто")),
          ],
        ),
      ),
    );
  }
}
Widget _buildMainHeader(String title) {
  return Padding(
    // Делаем отступы такими же, как у карточек, чтобы всё было по одной линии
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 22, // Чуть увеличили для акцента
        fontWeight: FontWeight.bold,
        color: AppTheme.dark,
      ),
    ),
  );
}