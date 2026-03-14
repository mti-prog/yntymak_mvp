import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/api/api_service.dart';
import '../../models/service_model.dart';
import '../../screens/main_screens/add_post_screen/add_post_screen.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ServiceItem> _services = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool _isServicesGrid = false;
  bool _isHelpGrid = false;
  bool _isFavoritesGrid = false;
  bool _isProfileGrid = false;

  ServiceProvider() {
    loadData();
  }

  // ── Геттеры ──────────────────────────────────────────────────────────────

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  bool get isServicesGrid => _isServicesGrid;
  bool get isHelpGrid => _isHelpGrid;
  bool get isFavoritesGrid => _isFavoritesGrid;
  bool get isProfileGrid => _isProfileGrid;

  void toggleServicesGrid() {
    _isServicesGrid = !_isServicesGrid;
    notifyListeners();
  }

  void toggleHelpGrid() {
    _isHelpGrid = !_isHelpGrid;
    notifyListeners();
  }

  void toggleFavoritesGrid() {
    _isFavoritesGrid = !_isFavoritesGrid;
    notifyListeners();
  }

  void toggleProfileGrid() {
    _isProfileGrid = !_isProfileGrid;
    notifyListeners();
  }

  List<ServiceItem> get services => _services;

  List<ServiceItem> get offers =>
      _services.where((s) => s.type == ServiceType.offer).toList();

  List<ServiceItem> get requests =>
      _services.where((s) => s.type == ServiceType.request).toList();

  List<ServiceItem> get favorites =>
      _services.where((s) => s.isFavorite).toList();

  /// Посты текущего пользователя — для ProfileScreen
  List<ServiceItem> userOffers(String userId) => _services
      .where((s) => s.userId == userId && s.type == ServiceType.offer)
      .toList();

  List<ServiceItem> userRequests(String userId) => _services
      .where((s) => s.userId == userId && s.type == ServiceType.request)
      .toList();

  // ── Добавление поста ──────────────────────────────────────────────────────

  Future<String?> addPost(
    String title,
    String description,
    PostType type, {
    required String userName,
    required String userPhone,
    String userAvatar = '',
    int price = 0,
    String category = 'other',
  }) async {
    final user = Supabase.instance.client.auth.currentUser;

    final newItem = ServiceItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      userAvatar: userAvatar,
      title: title,
      description: description,
      phoneNumber: userPhone,
      isPaid: price > 0,
      price: price,
      type: type == PostType.service ? ServiceType.offer : ServiceType.request,
      userId: user?.id,
      category: category,
    );

    try {
      await _apiService.insertPost(newItem);
      await loadData();
      return null;
    } catch (e) {
      debugPrint('Error inserting post: $e');
      return e.toString();
    }
  }

  // ── Удаление поста ────────────────────────────────────────────────────────

  Future<String?> deletePost(String id) async {
    try {
      await _apiService.deletePost(id);
      _services.removeWhere((s) => s.id == id);
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Error deleting post: $e');
      return e.toString();
    }
  }

  // ── Загрузка данных (первая страница) ─────────────────────────────────────

  Future<void> loadData() async {
    _isLoading = true;
    _hasMore = true;
    notifyListeners();

    try {
      final fetchedData = await _apiService.fetchServices(offset: 0);
      _services = fetchedData;
      _hasMore = fetchedData.length >= ApiService.pageSize;
      await _loadFavorites();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Подгрузка следующей страницы ──────────────────────────────────────────

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final moreData = await _apiService.fetchServices(
        offset: _services.length,
      );
      if (moreData.isEmpty) {
        _hasMore = false;
      } else {
        _services.addAll(moreData);
        _hasMore = moreData.length >= ApiService.pageSize;
        await _loadFavorites();
      }
    } catch (e) {
      debugPrint('Error loading more data: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final rows = await Supabase.instance.client
          .from('favorites')
          .select('post_id')
          .eq('user_id', userId);

      final favIds = (rows as List).map((r) => r['post_id'] as String).toSet();

      for (var service in _services) {
        service.isFavorite = favIds.contains(service.id);
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // ── Избранное ─────────────────────────────────────────────────────────────

  void toggleFavorite(String id) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final index = _services.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final wasFavorite = _services[index].isFavorite;
    _services[index].isFavorite = !wasFavorite;
    notifyListeners();

    try {
      if (wasFavorite) {
        // Удаляем из избранного
        await Supabase.instance.client
            .from('favorites')
            .delete()
            .eq('user_id', userId)
            .eq('post_id', id);
      } else {
        // Добавляем в избранное
        await Supabase.instance.client.from('favorites').insert({
          'user_id': userId,
          'post_id': id,
        });
      }
    } catch (e) {
      // Откатываем при ошибке
      _services[index].isFavorite = wasFavorite;
      notifyListeners();
      debugPrint('Error toggling favorite: $e');
    }
  }
}
