import '../entities/bible_version.dart';
import '../entities/verse.dart';

abstract class IBibleRepository {
  Future<List<BibleVersion>> getBibleVersions();
  Future<List<Verse>> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  });
}
