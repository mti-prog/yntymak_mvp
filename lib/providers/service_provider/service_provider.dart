import 'package:flutter/material.dart';
import '../../core/storage_service/storage_service.dart';
import '../../models/service_model.dart';

class ServiceProvider extends ChangeNotifier {
  // Объединяем все данные в один список
  final List<ServiceItem> _services = [
    // Твои dummy-данные из ServiceScreen
    ServiceItem(
      id: '1',
      userName: 'Адилет Саматов',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      title: 'Ремонт смартфонов и ноутбуков...',
      phoneNumber: '+996700123456',
      isPaid: true,
      type: ServiceType.offer,
    ),
    // Твои dummy-данные из HelpScreen
    ServiceItem(
      id: 'h1',
      userName: 'Айсулуу Маратова',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      title: 'Нужна помощь с перевозкой вещей...',
      phoneNumber: '+996555112233',
      isPaid: false,
      type: ServiceType.request, // Это запрос помощи
    ),
    // ... добавь остальные элементы сюда
  ];

  // Геттер для получения всех услуг
  // Добавляем конструктор
  ServiceProvider() {
    _loadFavorites();
  }

  List<ServiceItem> get services => _services;
  List<ServiceItem> get offers => _services.where((s) => s.type == ServiceType.offer).toList();
  List<ServiceItem> get requests => _services.where((s) => s.type == ServiceType.request).toList();
  List<ServiceItem> get favorites => _services.where((s) => s.isFavorite).toList();

  // Загрузка избранного при старте
  Future<void> _loadFavorites() async {
    final savedIds = await StorageService.getFavorites();
    if (savedIds.isNotEmpty) {
      for (var service in _services) {
        if (savedIds.contains(service.id)) {
          service.isFavorite = true;
        }
      }
      notifyListeners();
    }
  }

  // Обновленный метод переключения
  void toggleFavorite(String id) async {
    final index = _services.indexWhere((item) => item.id == id);
    if (index != -1) {
      _services[index].isFavorite = !_services[index].isFavorite;

      // Сразу сохраняем текущее состояние в SharedPreferences
      final favoriteIds = _services
          .where((s) => s.isFavorite)
          .map((s) => s.id)
          .toList();
      await StorageService.saveFavorites(favoriteIds);

      notifyListeners();
    }
  }
}