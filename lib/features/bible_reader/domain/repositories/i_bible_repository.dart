import '../entities/bible_version.dart';
import '../entities/verse.dart';
import '../entities/book.dart';
import '../entities/search_filter.dart';

abstract class IBibleRepository {
  Future<List<BibleVersion>> getBibleVersions();
  Future<List<Book>> getBooks({String versionId = 'amh_standard'});
  Future<int> getChapterCount(String book, {String versionId = 'amh_standard'});
  Future<List<Verse>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  });
  Future<List<Verse>> searchVerses(String query, {
    String versionId = 'amh_standard',
    SearchFilter filter = SearchFilter.all,
  });
}
