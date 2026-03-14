import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../models/service_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../providers/volunteer_provider/volunteer_provider.dart';
import '../../../widgets/help_card.dart';
import '../../../widgets/help_grid_card.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/service_grid_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ServiceItem> _filter(List<ServiceItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items
        .where(
          (s) =>
              s.title.toLowerCase().contains(_searchQuery) ||
              s.description.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isVolunteer = auth.isVolunteerMode;
    final serviceProvider = context.watch<ServiceProvider>();
    final volunteerProvider = context.watch<VolunteerProvider>();
    context.watch<LocaleProvider>();

    final bool isGrid;
    if (isVolunteer) {
      isGrid = volunteerProvider.isFavoritesGrid;
    } else {
      isGrid = serviceProvider.isFavoritesGrid;
    }

    final tab1 = isVolunteer
        ? AppLocalizations.tr(context, 'tab_volunteers')
        : AppLocalizations.tr(context, 'tab_services');
    final tab2 = isVolunteer
        ? AppLocalizations.tr(context, 'tab_charity')
        : AppLocalizations.tr(context, 'tab_help');

    final bgColor = isVolunteer
        ? const Color(0xFFF0EBF2)
        : AppTheme.lightBlueBackground;
    final accentColor = isVolunteer
        ? const Color(0xFF7B1FA2)
        : AppTheme.baseGreen;
    final searchBg = isVolunteer
        ? const Color(0xFFE8DEF8)
        : AppTheme.lightGreenBackGround;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.tr(context, 'favourites_title'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dark,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (isVolunteer) {
                        volunteerProvider.toggleFavoritesGrid();
                      } else {
                        serviceProvider.toggleFavoritesGrid();
                      }
                    },
                    icon: Icon(
                      isGrid
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      color: AppTheme.dark,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: (q) =>
                    setState(() => _searchQuery = q.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: AppLocalizations.tr(context, 'search_favourites'),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.gray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              color: bgColor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.dark,
                unselectedLabelColor: AppTheme.gray,
                indicatorColor: accentColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                tabs: [
                  Tab(text: tab1),
                  Tab(text: tab2),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFavTab(
                    isVolunteer: isVolunteer,
                    type: ServiceType.offer,
                    isGrid: isGrid,
                    serviceProvider: serviceProvider,
                    volunteerProvider: volunteerProvider,
                    emptyText: isVolunteer
                        ? AppLocalizations.tr(context, 'no_fav_volunteers')
                        : AppLocalizations.tr(context, 'no_fav_services'),
                  ),
                  _buildFavTab(
                    isVolunteer: isVolunteer,
                    type: ServiceType.request,
                    isGrid: isGrid,
                    serviceProvider: serviceProvider,
                    volunteerProvider: volunteerProvider,
                    emptyText: isVolunteer
                        ? AppLocalizations.tr(context, 'no_fav_charity')
                        : AppLocalizations.tr(context, 'no_fav_help'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavTab({
    required bool isVolunteer,
    required ServiceType type,
    required bool isGrid,
    required ServiceProvider serviceProvider,
    required VolunteerProvider volunteerProvider,
    required String emptyText,
  }) {
    final List<ServiceItem> items;
    final void Function(String) onFav;

    if (isVolunteer) {
      items = _filter(
        volunteerProvider.favorites.where((s) => s.type == type).toList(),
      );
      onFav = volunteerProvider.toggleFavorite;
    } else {
      items = _filter(
        serviceProvider.favorites.where((s) => s.type == type).toList(),
      );
      onFav = serviceProvider.toggleFavorite;
    }

    final isService = type == ServiceType.offer;

    if (items.isEmpty) {
      return Center(
        child: Text(emptyText, style: const TextStyle(color: AppTheme.gray)),
      );
    }

    if (isGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (isService) {
            return ServiceGridCard(
              service: item,
              onFavoritePressed: () => onFav(item.id),
            );
          } else {
            return HelpGridCard(
              service: item,
              onFavoritePressed: () => onFav(item.id),
            );
          }
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (isService) {
          return ServiceCard(
            service: item,
            onFavoritePressed: () => onFav(item.id),
          );
        } else {
          return HelpCard(
            service: item,
            onFavoritePressed: () => onFav(item.id),
          );
        }
      },
    );
  }
}
