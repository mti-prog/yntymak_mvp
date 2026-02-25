import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';
import '../../core/storage_service/storage_service.dart';
import '../../models/service_model.dart';
import '../../screens/main_screens/add_post_screen/add_post_screen.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ServiceItem> _services = [];
  bool _isLoading = false;
  String _searchQuery = '';

  ServiceProvider() {
    loadData();
  }

  // ── Геттеры ──────────────────────────────────────────────────────────────

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  /// Все записи, отфильтрованные по текущему _searchQuery
  List<ServiceItem> get services => _filtered(_services);

  List<ServiceItem> get offers =>
      _filtered(_services.where((s) => s.type == ServiceType.offer).toList());

  List<ServiceItem> get requests =>
      _filtered(_services.where((s) => s.type == ServiceType.request).toList());

  List<ServiceItem> get favorites =>
      _services.where((s) => s.isFavorite).toList();

  // ── Поиск ────────────────────────────────────────────────────────────────

  /// Вызывается из TextField.onChanged — фильтрует список по title
  void searchServices(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  /// Применяет поисковый фильтр к произвольному списку
  List<ServiceItem> _filtered(List<ServiceItem> source) {
    if (_searchQuery.isEmpty) return source;
    return source
        .where((s) => s.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  // ── Добавление поста ──────────────────────────────────────────────────────

  /// Возвращает null при успехе, строку с ошибкой при неудаче.
  Future<String?> addPost(String title, PostType type) async {
    final newItem = ServiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'Current User',
      userAvatar: '',
      title: title,
      phoneNumber: '123-456-7890',
      isPaid: false,
      type: type == PostType.service ? ServiceType.offer : ServiceType.request,
    );

    try {
      await _apiService.insertPost(newItem);
      await loadData();
      return null; // успех
    } catch (e) {
      debugPrint('Error inserting post: $e');
      return e.toString(); // возвращаем текст ошибки
    }
  }

  // ── Загрузка данных ───────────────────────────────────────────────────────

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedData = await _apiService.fetchServices();
      _services = fetchedData;
      await _loadFavorites();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    final savedIds = await StorageService.getFavorites();
    if (savedIds.isNotEmpty) {
      for (var service in _services) {
        if (savedIds.contains(service.id)) {
          service.isFavorite = true;
        }
      }
    }
  }

  // ── Избранное ─────────────────────────────────────────────────────────────

  void toggleFavorite(String id) async {
    final index = _services.indexWhere((item) => item.id == id);
    if (index != -1) {
      _services[index].isFavorite = !_services[index].isFavorite;

      final favoriteIds = _services
          .where((s) => s.isFavorite)
          .map((s) => s.id)
          .toList();
      await StorageService.saveFavorites(favoriteIds);

      notifyListeners();
    }
  }
}
