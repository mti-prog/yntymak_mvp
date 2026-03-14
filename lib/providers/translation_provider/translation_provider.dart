import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

/// Provides on-demand translation of user-generated text with caching.
class TranslationProvider extends ChangeNotifier {
  final _translator = GoogleTranslator();

  // Cache structure: { "en:Hello world" => "Привет мир" }
  // Key = targetLang:originalText
  final Map<String, String> _cache = {};

  // Track in-flight requests to avoid duplicates
  final Set<String> _pending = {};

  /// Returns the translated text if cached, otherwise starts async translation
  /// and returns [original] as placeholder until ready.
  String translate(String original, String targetLang) {
    if (original.trim().isEmpty) return original;

    final key = '$targetLang:$original';

    // Already cached
    if (_cache.containsKey(key)) return _cache[key]!;

    // Already loading — return original as placeholder
    if (_pending.contains(key)) return original;

    // Start async translation
    _pending.add(key);
    _translateAsync(original, targetLang, key);

    return original; // placeholder while translating
  }

  Future<void> _translateAsync(
    String text,
    String targetLang,
    String cacheKey,
  ) async {
    try {
      final result = await _translator.translate(text, to: targetLang);
      _cache[cacheKey] = result.text;
    } catch (e) {
      // On error, cache the original text so we don't retry forever
      _cache[cacheKey] = text;
      debugPrint('Translation error: $e');
    } finally {
      _pending.remove(cacheKey);
      notifyListeners(); // trigger rebuild with translated text
    }
  }

  /// Clears the cache (e.g. when user switches language)
  void clearCache() {
    _cache.clear();
    _pending.clear();
  }
}
