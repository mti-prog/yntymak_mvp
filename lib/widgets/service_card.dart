import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback onFavoritePressed;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1B334B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            // Используем современный withValues вместо withOpacity
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар слева
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(service.userAvatar),
          ),
          const SizedBox(width: 16),
          // Основной контент
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Имя и Сердечко
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: onFavoritePressed,
                      child: IconButton(
                        icon: Icon(
                          service.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: service.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: onFavoritePressed, // Это вызывает функцию, которую мы передали из экрана
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Описание (Title)
                Text(
                  service.title,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Цена и Номер телефона
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service.isPaid ? 'Paid' : 'Free',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.phoneNumber,
                        style: const TextStyle(
                          color: Colors.white,
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