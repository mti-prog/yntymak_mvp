import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/service_model.dart';
import '../screens/main_screens/detail_screen/service_details_screen.dart';

class HelpCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onFavoritePressed;

  const HelpCard({
    super.key,
    required this.service,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Оборачиваем всё в GestureDetector для перехода
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightGreenBackGround,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Оборачиваем аватар в Hero для анимации
            Hero(
              tag: 'image_${service.id}', // Тег должен быть уникальным
              child: CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(service.userAvatar),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.dark,
                        ),
                      ),
                      // Кнопка избранного (убрал лишний GestureDetector вокруг IconButton)
                      IconButton(
                        icon: Icon(
                          service.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: service.isFavorite ? AppTheme.baseGreen : AppTheme.baseGreen,
                        ),
                        onPressed: onFavoritePressed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.dark,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.isPaid ? 'Paid' : 'Free',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.dark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.dark,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.phoneNumber,
                          style: const TextStyle(
                            color: AppTheme.lightBlueBackground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}