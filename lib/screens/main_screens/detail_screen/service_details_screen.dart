import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_theme.dart';
import '../../../models/service_model.dart';
import '../../../providers/service_provider/service_provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceItem service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // Слушаем изменения только этого конкретного элемента
    final currentService = context.watch<ServiceProvider>().services.firstWhere((s) => s.id == service.id);

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackGround,
      body: Column(
        children: [
          // Верхняя часть с картинкой и кнопками
          Stack(
            children: [
              Hero(
                tag: 'image_${service.id}', // Тег должен совпадать с тегом в списке
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(service.userAvatar), // Здесь можно заменить на картинку услуги, если она есть в модели
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Градиент для того, чтобы кнопки были видны на любом фоне
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.lightGreenBackGround),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          currentService.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: currentService.isFavorite ? AppTheme.baseGreen : AppTheme.baseGreen,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<ServiceProvider>().toggleFavorite(service.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Основной контент
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: AppTheme.lightGreenBackGround,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Тип (Услуга / Помощь)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: service.type == ServiceType.offer
                            ? AppTheme.baseGreen
                            : AppTheme.baseGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        service.type == ServiceType.offer ? "Service Offer" : "Help Request",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.lightGreenBackGround),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Автор
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(service.userAvatar),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.userName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text("Author", style: TextStyle(color: AppTheme.gray)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      service.title,
                      style: const TextStyle(fontSize: 16, color: AppTheme.dark, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Закрепленная кнопка Contact
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
        decoration: BoxDecoration(
          color: AppTheme.lightGreenBackGround,
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Здесь будет логика звонка: launchUrl(Uri.parse('tel:${service.phoneNumber}'));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.dark,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.phone, color: AppTheme.lightGreenBackGround),
          label: const Text(
            "Contact",
            style: TextStyle(color: AppTheme.lightGreenBackGround, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}