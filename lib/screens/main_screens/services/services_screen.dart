import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../providers/service_provider/service_provider.dart';
import '../../../widgets/service_card.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Подписываемся на изменения в провайдере
    // Используем геттер .offers, который мы создали в ServiceProvider
    final offers = context.watch<ServiceProvider>().offers;

    return Scaffold(
      backgroundColor: AppTheme.lightBlueBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
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

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.lightGreenBackGround,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a services...',
                  prefixIcon: Icon(Icons.search, color: AppTheme.gray),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            // Список услуг
            Expanded(
              child: offers.isEmpty
                  ? const Center(child: Text("No services available"))
                  : ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final item = offers[index];
                  return ServiceCard(
                    service: item,
                    onFavoritePressed: () {
                      // 2. Вызываем метод переключения избранного
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
  }}