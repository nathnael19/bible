import '../entities/bible_version.dart';
import '../repositories/i_bible_repository.dart';

class GetBibleVersions {
  final IBibleRepository repository;
  const GetBibleVersions(this.repository);

  Future<List<BibleVersion>> call() => repository.getBibleVersions();
}
