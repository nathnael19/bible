import '../entities/verse.dart';
import '../entities/search_filter.dart';
import '../repositories/i_bible_repository.dart';

class SearchVerses {
  final IBibleRepository repository;

  SearchVerses(this.repository);

  Future<List<Verse>> call(String query, {
    String versionId = 'amh_standard',
    SearchFilter filter = SearchFilter.all,
  }) async {
    return repository.searchVerses(query, versionId: versionId, filter: filter);
  }
}
