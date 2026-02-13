import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/service_model.dart';

class ApiService {
  // КОГДА ПОЯВИТСЯ БЭКЕНД - ПРОСТО ЗАМЕНИ ЭТУ ССЫЛКУ
  static const String baseUrl = "https://run.mocky.io/v3/your-mock-id";

  Future<List<ServiceItem>> fetchServices() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        // Предполагаем, что сервер возвращает массив объектов
        return body.map((json) => ServiceItem.fromJson(json)).toList();
      } else {
        throw Exception("Ошибка сервера: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Ошибка при запросе данных: $e");
    }
  }
}