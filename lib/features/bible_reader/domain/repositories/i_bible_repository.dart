import '../entities/bible_version.dart';
import '../entities/verse.dart';
import '../entities/book.dart';

abstract class IBibleRepository {
  Future<List<BibleVersion>> getBibleVersions();
  Future<List<Book>> getBooks();
  Future<int> getChapterCount(String book);
  Future<List<Verse>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  });
}
