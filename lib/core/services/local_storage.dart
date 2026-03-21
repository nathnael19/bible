import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  static const String _themeKey = 'app_theme_mode';
  static const String _bookmarksPrefix = 'bookmarks_';

  // ── Theme ──────────────────────────────────────────────────────────────────

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  ThemeMode getThemeMode() {
    final modeName = _prefs.getString(_themeKey);
    if (modeName == null) return ThemeMode.light;
    return ThemeMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ThemeMode.light,
    );
  }

  // ── Bookmarks ──────────────────────────────────────────────────────────────

  String _getBookmarkKey(String bookId, int chapter) => '$_bookmarksPrefix${bookId}_$chapter';

  Future<void> saveBookmarks(String bookId, int chapter, Set<int> bookmarks) async {
    final key = _getBookmarkKey(bookId, chapter);
    if (bookmarks.isEmpty) {
      await _prefs.remove(key);
    } else {
      await _prefs.setStringList(key, bookmarks.map((e) => e.toString()).toList());
    }
  }

  Set<int> getBookmarks(String bookId, int chapter) {
    final key = _getBookmarkKey(bookId, chapter);
    final list = _prefs.getStringList(key);
    if (list == null) return {};
    return list.map((e) => int.parse(e)).toSet();
  }

  Map<String, Set<int>> getAllBookmarksKeys() {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_bookmarksPrefix));
    final allBookmarks = <String, Set<int>>{};
    for (final key in keys) {
      final list = _prefs.getStringList(key);
      if (list != null) {
        allBookmarks[key] = list.map((e) => int.parse(e)).toSet();
      }
    }
    return allBookmarks;
  }

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String _authKey = 'is_logged_in';
  static const String _usernameKey = 'user_name';

  bool isLoggedIn() => _prefs.getBool(_authKey) ?? false;
  Future<void> setLoggedIn(bool value) async => await _prefs.setBool(_authKey, value);

  String? getUsername() => _prefs.getString(_usernameKey);
  Future<void> setUsername(String value) async => await _prefs.setString(_usernameKey, value);
  Future<void> clearUsername() async => await _prefs.remove(_usernameKey);
}
