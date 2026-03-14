import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  User? _user;
  String? _userName;
  String? _userPhone;
  String? _avatarUrl;
  bool _isLoading = false;
  bool _isVolunteerMode = false;
  String _accountType = 'user';
  bool _isVerified = false;

  // Saved accounts
  List<Map<String, String>> _savedAccounts = [];

  AuthProvider() {
    _user = _client.auth.currentUser;
    if (_user != null) _fetchProfile();
    _loadSavedAccounts();

    _client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      if (_user != null) {
        _fetchProfile();
      } else {
        _userName = null;
        _userPhone = null;
        _avatarUrl = null;
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
  String? get avatarUrl => _avatarUrl;
  bool get isVolunteerMode =>
      _isVolunteerMode || _accountType == 'organization';
  String get accountType => _accountType;
  bool get isOrganization => _accountType == 'organization';
  bool get isVerified => _isVerified;
  List<Map<String, String>> get savedAccounts => _savedAccounts;

  void toggleVolunteerMode() {
    if (_accountType == 'organization') return; // orgs can't toggle
    _isVolunteerMode = !_isVolunteerMode;
    notifyListeners();
  }

  // ── Регистрация ───────────────────────────────────────────────────────────

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    String phone = '',
    String accountType = 'user',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'phone': phone, 'account_type': accountType},
      );
      if (response.user == null) return 'Registration failed: no user returned';

      _user = response.user;
      _userName = name;
      _userPhone = phone;
      _accountType = accountType;

      // Wait for profile trigger to create row, then update account_type
      if (_user != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        try {
          await _client
              .from('profiles')
              .update({'account_type': accountType})
              .eq('id', _user!.id);
        } catch (e) {
          debugPrint('Could not update account_type: $e');
          // Retry once after a short delay
          await Future.delayed(const Duration(seconds: 1));
          try {
            await _client
                .from('profiles')
                .update({'account_type': accountType})
                .eq('id', _user!.id);
          } catch (_) {}
        }
      }

      await _saveCurrentAccount();
      return null;
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
      await _saveCurrentAccount();
      return null;
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
    _avatarUrl = null;
    notifyListeners();
  }

  // ── Saved Accounts ───────────────────────────────────────────────────────────

  static const _savedAccountsKey = 'saved_accounts';

  Future<void> _loadSavedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_savedAccountsKey) ?? [];
    _savedAccounts = json
        .map((s) => Map<String, String>.from(jsonDecode(s) as Map))
        .toList();
    notifyListeners();
  }

  Future<void> _saveCurrentAccount() async {
    if (_user == null) return;
    final email = _user!.email ?? '';
    if (email.isEmpty) return;

    final account = {
      'email': email,
      'name': _userName ?? email,
      'accountType': _accountType,
      'avatarUrl': _avatarUrl ?? '',
    };

    // Remove existing entry for same email
    _savedAccounts.removeWhere((a) => a['email'] == email);
    // Add to top
    _savedAccounts.insert(0, account);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _savedAccountsKey,
      _savedAccounts.map((a) => jsonEncode(a)).toList(),
    );
    notifyListeners();
  }

  Future<void> removeSavedAccount(String email) async {
    _savedAccounts.removeWhere((a) => a['email'] == email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _savedAccountsKey,
      _savedAccounts.map((a) => jsonEncode(a)).toList(),
    );
    notifyListeners();
  }

  // ── Загрузка аватара ──────────────────────────────────────────────────────

  /// Выбирает фото из галереи, загружает в Storage, сохраняет URL в profiles.
  /// Возвращает null при успехе, строку ошибки при неудаче.
  Future<String?> pickAndUploadAvatar() async {
    if (_user == null) return 'Not logged in';

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (picked == null) return null; // отменил выбор — не ошибка

      final fileBytes = await picked.readAsBytes();
      final ext = picked.name.split('.').last;
      final path = '${_user!.id}/avatar.$ext';

      // Загружаем в Supabase Storage (перезаписываем если есть)
      await _client.storage
          .from('avatars')
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Получаем публичный URL
      final publicUrl = _client.storage.from('avatars').getPublicUrl(path);

      // Сохраняем URL в profiles
      await _client
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', _user!.id);

      _avatarUrl = publicUrl;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      return e.toString();
    }
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
      _accountType = (data['account_type'] as String?) ?? 'user';
      _isVerified = (data['is_verified'] as bool?) ?? false;
      final url = data['avatar_url'] as String?;
      _avatarUrl = (url != null && url.isNotEmpty) ? url : null;
      notifyListeners();
    } catch (_) {
      // профиль ещё не создан
    }
  }
}
