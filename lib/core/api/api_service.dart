import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/service_model.dart';

class ApiService {
  final _client = Supabase.instance.client;

  static const int pageSize = 20;

  // ── Service Posts ─────────────────────────────────────────────────────────

  /// Paginated fetch: returns [pageSize] items starting from [offset].
  Future<List<ServiceItem>> fetchServices({int offset = 0}) async {
    final response = await _client
        .from('service_posts')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + pageSize - 1);

    return (response as List<dynamic>)
        .map((row) => ServiceItem.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Загружает посты конкретного пользователя
  Future<List<ServiceItem>> fetchUserPosts(String userId) async {
    final response = await _client
        .from('service_posts')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => ServiceItem.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Сохраняет новый пост в Supabase (INSERT)
  Future<void> insertPost(ServiceItem item) async {
    await _client.from('service_posts').insert(item.toJson());
  }

  /// Удаляет пост по ID
  Future<void> deletePost(String id) async {
    await _client.from('service_posts').delete().eq('id', id);
  }

  // ── Volunteer Posts ───────────────────────────────────────────────────────

  /// Paginated fetch for volunteer posts.
  Future<List<ServiceItem>> fetchVolunteerPosts({int offset = 0}) async {
    final response = await _client
        .from('volunteer_posts')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + pageSize - 1);

    return (response as List<dynamic>)
        .map((row) => ServiceItem.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Сохраняет волонтёрский пост
  Future<void> insertVolunteerPost(ServiceItem item) async {
    await _client.from('volunteer_posts').insert(item.toJson());
  }

  /// Удаляет волонтёрский пост по ID
  Future<void> deleteVolunteerPost(String id) async {
    await _client.from('volunteer_posts').delete().eq('id', id);
  }
}
