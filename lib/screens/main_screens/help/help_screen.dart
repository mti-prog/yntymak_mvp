import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../models/service_model.dart';
import '../../../providers/locale_provider/locale_provider.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/help_card.dart';
import '../../../widgets/help_grid_card.dart';
import '../add_post_screen/add_post_screen.dart';

class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({super.key});

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> {
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
    final provider = context.watch<ServiceProvider>();
    final helpRequests = _filter(provider.requests);
    final isGrid = provider.isHelpGrid;
    context.watch<LocaleProvider>();

    final cats = AppLocalizations.categories(context, 'help');

    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.tr(context, 'help_title'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dark,
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.toggleHelpGrid(),
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
            _buildSearchBar(AppLocalizations.tr(context, 'search_help')),
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
                        child: helpRequests.isEmpty
                            ? ListView(
                                children: [
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      AppLocalizations.tr(context, 'no_help'),
                                    ),
                                  ),
                                ],
                              )
                            : isGrid
                            ? _buildGrid(helpRequests, provider.isLoadingMore)
                            : _buildList(helpRequests, provider.isLoadingMore),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(type: PostType.help),
            ),
          );
        },
        backgroundColor: AppTheme.baseGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryChips(Map<String, String> categories) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildChip('all', AppLocalizations.allChip(context, '🤝')),
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
        selectedColor: AppTheme.baseGreen,
        backgroundColor: AppTheme.lightGreenBackGround,
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
        return HelpCard(
          service: item,
          onFavoritePressed: () {
            context.read<ServiceProvider>().toggleFavorite(item.id);
          },
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
            return HelpGridCard(
              service: item,
              onFavoritePressed: () {
                context.read<ServiceProvider>().toggleFavorite(item.id);
              },
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
        color: AppTheme.lightGreenBackGround,
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
