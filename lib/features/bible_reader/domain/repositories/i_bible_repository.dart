import '../entities/bible_version.dart';
import '../entities/verse.dart';
import '../entities/book.dart';
import '../entities/search_filter.dart';

abstract class IBibleRepository {
  Future<List<BibleVersion>> getBibleVersions();
  Future<List<Book>> getBooks();
  Future<int> getChapterCount(String book);
  Future<List<Verse>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  });
  Future<List<Verse>> searchVerses(String query, {SearchFilter filter = SearchFilter.all});
}
