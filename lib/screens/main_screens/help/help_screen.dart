import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/help_card.dart';


class HelpRequestsScreen extends StatelessWidget {
  const HelpRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем список запросов из провайдера
    final helpRequests = context.watch<ServiceProvider>().requests;

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
                  const Text(
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

            // Search Bar
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
            Expanded(
              child: ListView.builder(
                itemCount: helpRequests.length,
                itemBuilder: (context, index) {
                  final item = helpRequests[index];
                  return HelpCard(
                    service: item,
                    onFavoritePressed: () {
                      // Вызываем метод через read
                      context.read<ServiceProvider>().toggleFavorite(item.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
