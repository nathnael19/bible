import '../entities/verse.dart';
import '../entities/search_filter.dart';
import '../repositories/i_bible_repository.dart';

class SearchVerses {
  final IBibleRepository repository;

  SearchVerses(this.repository);

  Future<List<Verse>> call(String query, {SearchFilter filter = SearchFilter.all}) async {
    return repository.searchVerses(query, filter: filter);
  }
}
