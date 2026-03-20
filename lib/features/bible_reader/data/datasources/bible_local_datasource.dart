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
    final List<BookModel> books = [];
    if (_cachedBible != null) {
      for (final b in _cachedBible!) {
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
