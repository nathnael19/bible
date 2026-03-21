import '../repositories/i_bible_repository.dart';

class GetChapterCount {
  final IBibleRepository repository;

  GetChapterCount(this.repository);

  Future<int> call(String book, {String versionId = 'amh_standard'}) async {
    return repository.getChapterCount(book, versionId: versionId);
  }
}
