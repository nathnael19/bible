import '../entities/book.dart';
import '../repositories/i_bible_repository.dart';

class GetBooks {
  final IBibleRepository repository;

  GetBooks(this.repository);

  Future<List<Book>> call({String versionId = 'amh_standard'}) async {
    return repository.getBooks(versionId: versionId);
  }
}
