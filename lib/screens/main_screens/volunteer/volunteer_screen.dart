import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../models/service_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/volunteer_provider/volunteer_provider.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/service_grid_card.dart';
import '../add_post_screen/add_post_screen.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  List<ServiceItem> _filter(List<ServiceItem> items) {
    var result = items;
    if (_selectedCategory != 'all') {
      result = result.where((s) => s.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (s) =>
                s.title.toLowerCase().contains(_searchQuery) ||
                s.description.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VolunteerProvider>();
    final items = _filter(provider.volunteers);
    final isGrid = provider.isVolunteerGrid;
    context.watch<LocaleProvider>();

    final cats = AppLocalizations.categories(context, 'volunteer');

    return Scaffold(
      backgroundColor: AppTheme.orgBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.tr(context, 'volunteers_title'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dark,
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.toggleVolunteerGrid(),
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
            _buildSearchBar(AppLocalizations.tr(context, 'search_volunteers')),
            const SizedBox(height: 4),
            _buildCategoryChips(cats),
            const SizedBox(height: 8),
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.baseGreen,
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.metrics.pixels >=
                            scroll.metrics.maxScrollExtent - 200) {
                          provider.loadMore();
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () => provider.loadData(),
                        child: items.isEmpty
                            ? ListView(
                                children: [
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      AppLocalizations.tr(
                                        context,
                                        'no_volunteers',
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : isGrid
                            ? _buildGrid(items, provider.isLoadingMore)
                            : _buildList(items, provider.isLoadingMore),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: context.watch<AuthProvider>().isOrganization
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddPostScreen(type: PostType.volunteer),
                  ),
                );
              },
              backgroundColor: AppTheme.orgPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildCategoryChips(Map<String, String> categories) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildChip('all', AppLocalizations.allChip(context, '🙌')),
          ...categories.entries.map((e) => _buildChip(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildChip(String key, String label) {
    final selected = _selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : AppTheme.dark,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        selectedColor: AppTheme.orgPurple,
        backgroundColor: AppTheme.orgPurpleLight,
        onSelected: (_) => setState(() => _selectedCategory = key),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildList(List<ServiceItem> items, bool isLoadingMore) {
    return ListView.builder(
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.baseGreen),
            ),
          );
        }
        final item = items[index];
        return ServiceCard(
          service: item,
          onFavoritePressed: () =>
              context.read<VolunteerProvider>().toggleFavorite(item.id),
        );
      },
    );
  }

  Widget _buildGrid(List<ServiceItem> items, bool isLoadingMore) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = items[index];
            return ServiceGridCard(
              service: item,
              onFavoritePressed: () =>
                  context.read<VolunteerProvider>().toggleFavorite(item.id),
            );
          }, childCount: items.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.baseGreen),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar(String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.orgPurpleLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (q) => setState(() => _searchQuery = q.trim().toLowerCase()),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, color: AppTheme.gray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
