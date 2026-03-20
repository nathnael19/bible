import '../../domain/entities/bible_version.dart';
import '../../domain/entities/verse.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/i_bible_repository.dart';
import '../datasources/bible_local_datasource.dart';

class BibleRepositoryImpl implements IBibleRepository {
  final BibleLocalDataSource localDataSource;
  const BibleRepositoryImpl(this.localDataSource);

  @override
  Future<List<BibleVersion>> getBibleVersions() async {
    return localDataSource.getBibleVersions();
  }

  @override
  Future<List<Book>> getBooks() async {
    return localDataSource.getBooks();
  }

  @override
  Future<int> getChapterCount(String book) async {
    return localDataSource.getChapterCount(book);
  }

  @override
  Future<List<Verse>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  }) async {
    return localDataSource.getVerses(
      versionId: versionId,
      book: book,
      chapter: chapter,
    );
  }

  @override
  Future<List<Verse>> searchVerses(String query) async {
    return localDataSource.searchVerses(query);
  }
}
