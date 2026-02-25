import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  User? _user;
  String? _userName;
  String? _userPhone;
  bool _isLoading = false;

  AuthProvider() {
    // Синхронно берём текущую сессию (если уже залогинен)
    _user = _client.auth.currentUser;
    if (_user != null) _fetchProfile();

    // Следим за изменениями авторизации
    _client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      if (_user != null) {
        _fetchProfile();
      } else {
        _userName = null;
        _userPhone = null;
      }
      notifyListeners();
    });
  }

  // ── Геттеры ───────────────────────────────────────────────────────────────

  User? get currentUser => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String get userName => _userName ?? _user?.email ?? 'User';
  String get userEmail => _user?.email ?? '';
  String get userPhone => _userPhone ?? '';
  String get userId => _user?.id ?? '';

  // ── Регистрация ───────────────────────────────────────────────────────────

  /// Возвращает null при успехе, строку ошибки при неудаче
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    String phone = '',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final uid = response.user?.id;
      if (uid == null) return 'Registration failed: no user returned';

      // Создаём запись в profiles
      await _client.from('profiles').insert({
        'id': uid,
        'name': name,
        'phone': phone,
        'avatar_url': '',
      });

      _user = response.user;
      _userName = name;
      _userPhone = phone;
      return null; // успех
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Вход ──────────────────────────────────────────────────────────────────

  /// Возвращает null при успехе, строку ошибки при неудаче
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _user = response.user;
      await _fetchProfile();
      return null; // успех
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Выход ─────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _client.auth.signOut();
    _user = null;
    _userName = null;
    _userPhone = null;
    notifyListeners();
  }

  // ── Вспомогательные ───────────────────────────────────────────────────────

  Future<void> _fetchProfile() async {
    if (_user == null) return;
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', _user!.id)
          .single();
      _userName = data['name'] as String?;
      _userPhone = data['phone'] as String?;
      notifyListeners();
    } catch (_) {
      // профиль ещё не создан — ничего не делаем
    }
  }
}
