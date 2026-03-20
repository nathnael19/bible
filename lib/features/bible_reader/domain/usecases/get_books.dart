import '../entities/book.dart';
import '../repositories/i_bible_repository.dart';

class GetBooks {
  final IBibleRepository repository;

  GetBooks(this.repository);

  Future<List<Book>> call() async {
    return repository.getBooks();
  }
}
