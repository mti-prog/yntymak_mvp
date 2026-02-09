import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/service_model.dart';

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

    return Container(
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
          // Аватар пользователя
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(service.userAvatar),
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
                    // Кнопка избранного
                    GestureDetector(
                      onTap: onFavoritePressed,
                      child: IconButton(
                        icon: Icon(
                          service.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: service.isFavorite ? AppTheme.baseGreen : AppTheme.gray,
                        ),
                        onPressed: onFavoritePressed, // Это вызывает функцию, которую мы передали из экрана
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Текст запроса
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
                    // Кнопка с номером
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
    );
  }
}