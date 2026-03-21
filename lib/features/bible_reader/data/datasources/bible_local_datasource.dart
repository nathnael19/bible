import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bible_version_model.dart';
import '../models/verse_model.dart';
import '../models/book_model.dart';
import '../../domain/entities/search_filter.dart';

/// Local data source that loads the Amharic Bible from bundled JSON.
class BibleLocalDataSource {
  final Map<String, List<dynamic>> _cachedBibles = {};

  Future<void> _init(String versionId) async {
    if (_cachedBibles.containsKey(versionId)) return;
    
    String fileName;
    switch (versionId) {
      case 'eng_kjv':
        fileName = 'english_kjv.json';
        break;
      case 'amh_standard':
      default:
        fileName = 'amharic_bible.json';
        break;
    }

    try {
      final String response = await rootBundle.loadString('assets/bible/$fileName');
      _cachedBibles[versionId] = json.decode(response) as List<dynamic>;
    } catch (e) {
      _cachedBibles[versionId] = [];
      rethrow;
    }
  }

  List<BibleVersionModel> getBibleVersions() {
    return const [
      BibleVersionModel(
        id: 'amh_standard',
        name: 'አማርኛ መደበኛ',
        language: 'አማርኛ',
        abbreviation: 'ASV',
      ),
      BibleVersionModel(
        id: 'eng_kjv',
        name: 'King James Version',
        language: 'English',
        abbreviation: 'KJV',
      ),
    ];
  }

  Future<List<BookModel>> getBooks({String versionId = 'amh_standard'}) async {
    await _init(versionId);
    final List<BookModel> books = [];
    final bible = _cachedBibles[versionId];
    if (bible != null) {
      for (final b in bible) {
        final id = b['book_id'] as int;
        final englishName = _getEnglishName(id);
        books.add(BookModel.fromJson(b, englishName));
      }
    }
    return books;
  }

  String _getEnglishName(int id) {
    const names = {
      1: 'GENESIS',
      2: 'EXODUS',
      3: 'LEVITICUS',
      4: 'NUMBERS',
      5: 'DEUTERONOMY',
      6: 'JOSHUA',
      7: 'JUDGES',
      8: 'RUTH',
      9: '1 SAMUEL',
      10: '2 SAMUEL',
      11: '1 KINGS',
      12: '2 KINGS',
      13: '1 CHRONICLES',
      14: '2 CHRONICLES',
      15: 'EZRA',
      16: 'NEHEMIAH',
      17: 'ESTHER',
      18: 'JOB',
      19: 'PSALMS',
      20: 'PROVERBS',
      21: 'ECCLESIASTES',
      22: 'SONG OF SOLOMON',
      23: 'ISAIAH',
      24: 'JEREMIAH',
      25: 'LAMENTATIONS',
      26: 'EZEKIEL',
      27: 'DANIEL',
      28: 'HOSEA',
      29: 'JOEL',
      30: 'AMOS',
      31: 'OBADIAH',
      32: 'JONAH',
      33: 'MICAH',
      34: 'NAHUM',
      35: 'HABAKKUK',
      36: 'ZEPHANIAH',
      37: 'HAGGAI',
      38: 'ZECHARIAH',
      39: 'MALACHI',
      40: 'MATTHEW',
      41: 'MARK',
      42: 'LUKE',
      43: 'JOHN',
      44: 'ACTS',
      45: 'ROMANS',
      46: '1 CORINTHIANS',
      47: '2 CORINTHIANS',
      48: 'GALATIANS',
      49: 'EPHESIANS',
      50: 'PHILIPPIANS',
      51: 'COLOSSIANS',
      52: '1 THESSALONIANS',
      53: '2 THESSALONIANS',
      54: '1 TIMOTHY',
      55: '2 TIMOTHY',
      56: 'TITUS',
      57: 'PHILEMON',
      58: 'HEBREWS',
      59: 'JAMES',
      60: '1 PETER',
      61: '2 PETER',
      62: '1 JOHN',
      63: '2 JOHN',
      64: '3 JOHN',
      65: 'JUDE',
      66: 'REVELATION',
    };
    return names[id] ?? 'BOOK $id';
  }

  Future<int> getChapterCount(String book, {String versionId = 'amh_standard'}) async {
    await _init(versionId);
    final bible = _cachedBibles[versionId];
    final bookData = bible?.firstWhere(
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
    await _init(versionId);
    
    final bible = _cachedBibles[versionId];
    final bookData = bible?.firstWhere(
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
        bookId: bookData['book_id'].toString(),
        chapter: chapter,
        text: v['text'],
      );
    }).toList();
  }

  Future<List<VerseModel>> searchVerses(String query, {
    String versionId = 'amh_standard',
    SearchFilter filter = SearchFilter.all,
  }) async {
    await _init(versionId);
    final bible = _cachedBibles[versionId];
    if (query.trim().isEmpty || bible == null) return [];

    final queryLower = query.toLowerCase();
    final results = <VerseModel>[];

    for (final book in bible) {
      final bookId = book['book_id'] as int;
      
      // Apply filter
      if (filter == SearchFilter.oldTestament && bookId > 39) continue;
      if (filter == SearchFilter.newTestament && bookId <= 39) continue;
      if (filter == SearchFilter.psalms && bookId != 19) continue;
      // translation filter is a no-op for now as we only have one translation

      final bookName = book['book_name'] as String;
      for (final chapter in book['chapters']) {
        final chapterNum = chapter['chapter'] as int;
        for (final verse in chapter['verses']) {
          final text = verse['text'] as String;
          if (text.toLowerCase().contains(queryLower)) {
            results.add(
              VerseModel(
                number: verse['verse'] as int,
                bookName: bookName,
                bookId: bookId.toString(),
                chapter: chapterNum,
                text: text,
              ),
            );
            // Cap results to prevent memory issues and UI stutter
            if (results.length >= 200) return results;
          }
        }
      }
    }
    return results;
  }
}
