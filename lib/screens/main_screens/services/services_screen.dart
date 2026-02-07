import 'package:flutter/material.dart';

import '../../../models/service_model.dart';
import '../../../widgets/service_card.dart';


class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}
class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDEEF3), // Фон как на макете
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B334B),
                    ),
                  ),
                ],
              ),
            ),
            // Поиск
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a services ot people...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            // Список
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: dummyServices.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    service: dummyServices[index],
                    onFavoritePressed: () {
                      dummyServices[index].isFavorite = !dummyServices[index].isFavorite;
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
List<ServiceItem> dummyServices = [
  ServiceItem(
    id: '1',
    userName: 'Адилет Саматов',
    userAvatar: 'https://i.pravatar.cc/150?img=1',
    title: 'Ремонт смартфонов и ноутбуков. Замена экранов, батарей. Быстро и с гарантией.',
    phoneNumber: '+996700123456',
    isPaid: true,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '2',
    userName: 'Айсулуу Маратова',
    userAvatar: 'https://i.pravatar.cc/150?img=5',
    title: 'Уроки английского языка для начинающих. Первое занятие бесплатно!',
    phoneNumber: '+996555112233',
    isPaid: false,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '3',
    userName: 'Белек Темиров',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    title: 'Перевозка вещей на легковом авто (хэтчбек). Помогу с переездом.',
    phoneNumber: '+996999000111',
    isPaid: true,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '3',
    userName: 'Белек Темиров',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    title: 'Перевозка вещей на легковом авто (хэтчбек). Помогу с переездом.',
    phoneNumber: '+996999000111',
    isPaid: true,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '3',
    userName: 'Белек Темиров',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    title: 'Перевозка вещей на легковом авто (хэтчбек). Помогу с переездом.',
    phoneNumber: '+996999000111',
    isPaid: true,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '3',
    userName: 'Белек Темиров',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    title: 'Перевозка вещей на легковом авто (хэтчбек). Помогу с переездом.',
    phoneNumber: '+996999000111',
    isPaid: true,
    type: ServiceType.offer,
  ),
  ServiceItem(
    id: '3',
    userName: 'Белек Темиров',
    userAvatar: 'https://i.pravatar.cc/150?img=8',
    title: 'Перевозка вещей на легковом авто (хэтчбек). Помогу с переездом.',
    phoneNumber: '+996999000111',
    isPaid: true,
    type: ServiceType.offer,
  ),
];