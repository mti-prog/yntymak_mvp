import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/help_card.dart';
import '../add_post_screen/add_post_screen.dart';

class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({super.key});

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();
    final helpRequests = provider.requests;

    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: Row(
                children: const [
                  Text(
                    'Help Requests',
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
            _buildSearchBar(context, 'Search for a help requests...'),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.baseGreen,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => provider.loadData(),
                      child: helpRequests.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: Text('No help requests available'),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: helpRequests.length,
                              itemBuilder: (context, index) {
                                final item = helpRequests[index];
                                return HelpCard(
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
              builder: (context) => const AddPostScreen(type: PostType.help),
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
