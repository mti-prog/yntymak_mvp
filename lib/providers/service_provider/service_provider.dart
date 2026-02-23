import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';
import '../../core/storage_service/storage_service.dart';
import '../../models/service_model.dart';
import '../../screens/main_screens/add_post_screen/add_post_screen.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Основной список теперь пустой, данные придут из сети
  List<ServiceItem> _services = [];
  bool _isLoading = false;

  // Конструктор: при создании провайдера сразу идем за данными
  ServiceProvider() {
    loadData();
  }

  // Геттеры
  List<ServiceItem> get services => _services;
  bool get isLoading => _isLoading;

  List<ServiceItem> get offers => _services.where((s) => s.type == ServiceType.offer).toList();
  List<ServiceItem> get requests => _services.where((s) => s.type == ServiceType.request).toList();
  List<ServiceItem> get favorites => _services.where((s) => s.isFavorite).toList();

  // Добавление нового поста локально
  void addPost(String title, PostType type) {
    final newItem = ServiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Временный уникальный ID
      userName: "Current User", // Имя по умолчанию
      userAvatar: "", // Пустая аватарка по умолчанию
      title: title,
      phoneNumber: "123-456-7890", // Номер телефона по умолчанию
      isPaid: false, // Бесплатно по умолчанию
      type: type == PostType.offer ? ServiceType.offer : ServiceType.request,
    );

    // Добавляем в начало списка
    _services.insert(0, newItem);
    notifyListeners();
  }

  // Основной метод загрузки данных из сети
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners(); // Показываем крутилку в UI

    try {
      // 1. Загружаем данные через ApiService
      final fetchedData = await _apiService.fetchServices();
      _services = fetchedData;

      // 2. Сразу проверяем локальное хранилище и восстанавливаем "сердечки"
      await _loadFavorites();
    } catch (e) {
      debugPrint("Error loading data: $e");
      // Здесь можно добавить переменную с текстом ошибки для UI
    } finally {
      _isLoading = false;
      notifyListeners(); // Скрываем крутилку
    }
  }

  // Загрузка избранного из памяти и применение к текущему списку
  Future<void> _loadFavorites() async {
    final savedIds = await StorageService.getFavorites();
    if (savedIds.isNotEmpty) {
      for (var service in _services) {
        if (savedIds.contains(service.id)) {
          service.isFavorite = true;
        }
      }
      // notifyListeners() вызовется в блоке finally метода loadData
    }
  }

  // Переключение избранного
  void toggleFavorite(String id) async {
    final index = _services.indexWhere((item) => item.id == id);
    if (index != -1) {
      _services[index].isFavorite = !_services[index].isFavorite;

      // Сохраняем в SharedPreferences
      final favoriteIds = _services
          .where((s) => s.isFavorite)
          .map((s) => s.id)
          .toList();
      await StorageService.saveFavorites(favoriteIds);

      notifyListeners();
    }
  }
}