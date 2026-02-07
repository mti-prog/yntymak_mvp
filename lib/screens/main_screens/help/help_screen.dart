import 'package:flutter/material.dart';
import '../../../models/service_model.dart';
import '../../../widgets/help_card.dart';


class HelpRequestsScreen extends StatefulWidget {
  const HelpRequestsScreen({super.key});

  @override
  State<HelpRequestsScreen> createState() => _HelpRequestsScreenState();
}

class _HelpRequestsScreenState extends State<HelpRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1B334B);

    // Фильтруем данные из твоего dummyServices
    // final helpRequests = dummyServices.where((s) => s.type == ServiceType.request).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3F1),
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
                    'Help Requests',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a help requests...',
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
                  return HelpCard(
                    service: dummyServices[index],
                    onFavoritePressed: () {
                      // Тут будет твой setState для лайка
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
    title:
        'Ремонт смартфонов и ноутбуков. Замена экранов, батарей. Быстро и с гарантией.',
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
