import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  static const String _themeKey = 'app_theme_mode';
  static const String _localeKey = 'app_locale';
  static const String _bookmarksPrefix = 'bookmarks_';

  // ── Theme ──────────────────────────────────────────────────────────────────

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  // ── Locale ─────────────────────────────────────────────────────────────────

  String getLocale() {
    return _prefs.getString(_localeKey) ?? 'am';
  }

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
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

  // ── Stats & History ────────────────────────────────────────────────────────
  static const String _lastReadBookKey = 'last_read_book';
  static const String _lastReadChapterKey = 'last_read_chapter';
  static const String _totalVersesReadKey = 'total_verses_read';
  static const String _readingHistoryKey = 'reading_history'; // List of ISO strings

  Future<void> recordReadingEvent(String book, int chapter) async {
    await _prefs.setString(_lastReadBookKey, book);
    await _prefs.setInt(_lastReadChapterKey, chapter);

    final today = DateTime.now().toIso8601String().split('T')[0];
    final history = _prefs.getStringList(_readingHistoryKey) ?? [];
    if (!history.contains(today)) {
      history.add(today);
      await _prefs.setStringList(_readingHistoryKey, history);
    }
  }

  String? getLastReadBook() => _prefs.getString(_lastReadBookKey);
  int getLastReadChapter() => _prefs.getInt(_lastReadChapterKey) ?? 1;

  int getTotalVersesRead() => _prefs.getInt(_totalVersesReadKey) ?? 0;
  Future<void> incrementVersesRead(int count) async {
    final current = getTotalVersesRead();
    await _prefs.setInt(_totalVersesReadKey, current + count);
  }

  List<String> getReadingHistory() => _prefs.getStringList(_readingHistoryKey) ?? [];

  int calculateStreak() {
    final history = getReadingHistory().toList();
    if (history.isEmpty) return 0;
    
    // Sort descending
    history.sort((a, b) => b.compareTo(a));
    
    final today = DateTime.now().toIso8601String().split('T')[0];
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];
    
    // If last entry is not today or yesterday, streak is broken
    if (history.first != today && history.first != yesterday) return 0;
    
    int streak = 1;
    for (int i = 0; i < history.length - 1; i++) {
      final current = DateTime.parse(history[i]);
      final next = DateTime.parse(history[i + 1]);
      if (current.difference(next).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // ── Reading Plans ──────────────────────────────────────────────────────────
  static const String _planProgressPrefix = 'plan_progress_';

  Future<void> toggleTaskCompletion(String planId, String taskId) async {
    final key = '$_planProgressPrefix$planId';
    final completed = _prefs.getStringList(key) ?? [];
    if (completed.contains(taskId)) {
      completed.remove(taskId);
    } else {
      completed.add(taskId);
    }
    await _prefs.setStringList(key, completed);
  }

  List<String> getCompletedTaskIds(String planId) {
    final key = '$_planProgressPrefix$planId';
    return _prefs.getStringList(key) ?? [];
  }

  Future<void> clearPlanProgress(String planId) async {
    final key = '$_planProgressPrefix$planId';
    await _prefs.remove(key);
  }
}
