import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bible_version_model.dart';
import '../models/verse_model.dart';
import '../models/book_model.dart';

/// Local data source that loads the Amharic Bible from bundled JSON.
class BibleLocalDataSource {
  List<dynamic>? _cachedBible;

  Future<void> _init() async {
    if (_cachedBible != null) return;
    try {
      final String response = await rootBundle.loadString('assets/bible/amharic_bible.json');
      _cachedBible = json.decode(response) as List<dynamic>;
    } catch (e) {
      _cachedBible = [];
      rethrow;
    }
  }

  List<BibleVersionModel> getBibleVersions() {
    return const [
      BibleVersionModel(
        id: 'amh_standard',
        name: 'Amharic Standard',
        language: 'አማርኛ',
        abbreviation: 'ASB',
      ),
    ];
  }

  Future<List<BookModel>> getBooks() async {
    await _init();
    return _cachedBible?.map((b) => BookModel.fromJson(b)).toList() ?? [];
  }

  Future<int> getChapterCount(String book) async {
    await _init();
    final bookData = _cachedBible?.firstWhere(
      (b) => b['book_name'] == book || b['book_id'].toString() == book,
      orElse: () => null,
    );
    return (bookData?['chapters'] as List?)?.length ?? 0;
  }

  Future<List<VerseModel>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  }) async {
    await _init();
    
    final bookData = _cachedBible?.firstWhere(
      (b) => b['book_name'] == book || b['book_id'].toString() == book,
      orElse: () => null,
    );

    if (bookData == null) return [];

    final chapterData = (bookData['chapters'] as List).firstWhere(
      (c) => c['chapter'] == chapter,
      orElse: () => null,
    );

    if (chapterData == null) return [];

    return (chapterData['verses'] as List).map((v) {
      return VerseModel(
        number: v['verse'],
        bookName: bookData['book_name'],
        chapter: chapter,
        text: v['text'],
      );
    }).toList();
  }
}
