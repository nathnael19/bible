import '../entities/verse.dart';
import '../repositories/i_bible_repository.dart';

class GetVerses {
  final IBibleRepository repository;
  const GetVerses(this.repository);

  Future<List<Verse>> call({
    required String versionId,
    required String book,
    required int chapter,
  }) =>
      repository.getVerses(versionId: versionId, book: book, chapter: chapter);
}
