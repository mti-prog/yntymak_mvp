import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/service_card.dart';
import '../add_post_screen/add_post_screen.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();
    final offers = provider.offers;

    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: Row(
                children: const [
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dark,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar — подключён к провайдеру
            _buildSearchBar(context, 'Search for a services...'),

            // Список или крутилка
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.baseGreen,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => provider.loadData(),
                      child: offers.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 100),
                                Center(child: Text('No services available')),
                              ],
                            )
                          : ListView.builder(
                              itemCount: offers.length,
                              itemBuilder: (context, index) {
                                final item = offers[index];
                                return ServiceCard(
                                  service: item,
                                  onFavoritePressed: () {
                                    context
                                        .read<ServiceProvider>()
                                        .toggleFavorite(item.id);
                                  },
                                );
                              },
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
              builder: (context) => const AddPostScreen(type: PostType.service),
            ),
          );
        },
        backgroundColor: AppTheme.baseGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, String hint) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightGreenBackGround,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (query) =>
            context.read<ServiceProvider>().searchServices(query),
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
