import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/service_model.dart';

class ApiService {
  // Единственный клиент на всё приложение (инициализирован в main.dart)
  final _client = Supabase.instance.client;

  /// Загружает все посты из Supabase (SELECT)
  Future<List<ServiceItem>> fetchServices() async {
    final response = await _client
        .from('service_posts')
        .select()
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((row) => ServiceItem.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Сохраняет новый пост в Supabase (INSERT)
  Future<void> insertPost(ServiceItem item) async {
    await _client.from('service_posts').insert(item.toJson());
  }
}
