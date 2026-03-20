import 'package:get_it/get_it.dart';

import '../../features/bible_reader/data/datasources/bible_local_datasource.dart';
import '../../features/bible_reader/data/repositories/bible_repository_impl.dart';
import '../../features/bible_reader/domain/repositories/i_bible_repository.dart';
import '../../features/bible_reader/domain/usecases/get_bible_versions.dart';
import '../../features/bible_reader/domain/usecases/get_verses.dart';
import '../../features/bible_reader/domain/usecases/get_books.dart';
import '../../features/bible_reader/domain/usecases/get_chapter_count.dart';
import '../../features/bible_reader/presentation/cubit/bible_reader_cubit.dart';
import '../../features/bible_reader/presentation/cubit/version_selector_cubit.dart';
import '../../features/bible_reader/presentation/cubit/library_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Data sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<BibleLocalDataSource>(
    () => BibleLocalDataSource(),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<IBibleRepository>(
    () => BibleRepositoryImpl(sl()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetBibleVersions(sl()));
  sl.registerLazySingleton(() => GetVerses(sl()));
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetChapterCount(sl()));

  // ── Cubits (factory — new instance each time) ─────────────────────────────
  sl.registerFactory(() => BibleReaderCubit(sl()));
  sl.registerFactory(() => VersionSelectorCubit(sl()));
  sl.registerFactory(() => LibraryCubit(sl()));
}
