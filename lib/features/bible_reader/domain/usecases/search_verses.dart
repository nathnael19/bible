import '../entities/verse.dart';
import '../repositories/i_bible_repository.dart';

class SearchVerses {
  final IBibleRepository repository;

  SearchVerses(this.repository);

  Future<List<Verse>> call(String query) async {
    return repository.searchVerses(query);
  }
}
