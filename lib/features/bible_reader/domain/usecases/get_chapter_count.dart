import '../repositories/i_bible_repository.dart';

class GetChapterCount {
  final IBibleRepository repository;

  GetChapterCount(this.repository);

  Future<int> call(String book) async {
    return repository.getChapterCount(book);
  }
}
