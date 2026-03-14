import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/api/api_service.dart';
import '../../models/service_model.dart';
import '../../screens/main_screens/add_post_screen/add_post_screen.dart';

class VolunteerProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ServiceItem> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  bool _isVolunteerGrid = false;
  bool _isCharityGrid = false;
  bool _isFavoritesGrid = false;

  VolunteerProvider() {
    loadData();
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  bool get isVolunteerGrid => _isVolunteerGrid;
  bool get isCharityGrid => _isCharityGrid;
  bool get isFavoritesGrid => _isFavoritesGrid;

  void toggleVolunteerGrid() {
    _isVolunteerGrid = !_isVolunteerGrid;
    notifyListeners();
  }

  void toggleCharityGrid() {
    _isCharityGrid = !_isCharityGrid;
    notifyListeners();
  }

  void toggleFavoritesGrid() {
    _isFavoritesGrid = !_isFavoritesGrid;
    notifyListeners();
  }

  List<ServiceItem> get volunteers =>
      _posts.where((s) => s.type == ServiceType.volunteer).toList();

  List<ServiceItem> get charityPosts =>
      _posts.where((s) => s.type == ServiceType.charity).toList();

  List<ServiceItem> get favorites => _posts.where((s) => s.isFavorite).toList();

  List<ServiceItem> userVolunteers(String userId) => _posts
      .where((s) => s.userId == userId && s.type == ServiceType.volunteer)
      .toList();

  List<ServiceItem> userCharity(String userId) => _posts
      .where((s) => s.userId == userId && s.type == ServiceType.charity)
      .toList();

  // ── Add post ─────────────────────────────────────────────────────────────

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
      type: type == PostType.volunteer
          ? ServiceType.volunteer
          : ServiceType.charity,
      userId: user?.id,
      category: category,
    );

    try {
      await _apiService.insertVolunteerPost(newItem);
      await loadData();
      return null;
    } catch (e) {
      debugPrint('Error inserting volunteer post: $e');
      return e.toString();
    }
  }

  // ── Delete ───────────────────────────────────────────────────────────────

  Future<String?> deletePost(String id) async {
    try {
      await _apiService.deleteVolunteerPost(id);
      _posts.removeWhere((s) => s.id == id);
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Error deleting volunteer post: $e');
      return e.toString();
    }
  }

  // ── Load data (first page) ──────────────────────────────────────────────

  Future<void> loadData() async {
    _isLoading = true;
    _hasMore = true;
    notifyListeners();

    try {
      _posts = await _apiService.fetchVolunteerPosts(offset: 0);
      _hasMore = _posts.length >= ApiService.pageSize;
      await _loadFavorites();
    } catch (e) {
      debugPrint('Error loading volunteer data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Load more (next page) ───────────────────────────────────────────────

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final moreData = await _apiService.fetchVolunteerPosts(
        offset: _posts.length,
      );
      if (moreData.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(moreData);
        _hasMore = moreData.length >= ApiService.pageSize;
        await _loadFavorites();
      }
    } catch (e) {
      debugPrint('Error loading more volunteer data: $e');
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
          .from('volunteer_favorites')
          .select('post_id')
          .eq('user_id', userId);

      final favIds = (rows as List).map((r) => r['post_id'] as String).toSet();

      for (var post in _posts) {
        post.isFavorite = favIds.contains(post.id);
      }
    } catch (e) {
      // volunteer_favorites table might not exist yet, that's ok
      debugPrint('Error loading volunteer favorites: $e');
    }
  }

  // ── Toggle favorite ──────────────────────────────────────────────────────

  void toggleFavorite(String id) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final index = _posts.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final wasFavorite = _posts[index].isFavorite;
    _posts[index].isFavorite = !wasFavorite;
    notifyListeners();

    try {
      if (wasFavorite) {
        await Supabase.instance.client
            .from('volunteer_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('post_id', id);
      } else {
        await Supabase.instance.client.from('volunteer_favorites').insert({
          'user_id': userId,
          'post_id': id,
        });
      }
    } catch (e) {
      _posts[index].isFavorite = wasFavorite;
      notifyListeners();
      debugPrint('Error toggling volunteer favorite: $e');
    }
  }
}
