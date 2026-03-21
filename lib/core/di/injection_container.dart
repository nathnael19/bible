import 'package:get_it/get_it.dart';

import '../../features/bible_reader/data/datasources/bible_local_datasource.dart';
import '../../features/bible_reader/data/repositories/bible_repository_impl.dart';
import '../../features/bible_reader/domain/repositories/i_bible_repository.dart';
import '../../features/bible_reader/domain/usecases/get_bible_versions.dart';
import '../../features/bible_reader/domain/usecases/get_verses.dart';
import '../../features/bible_reader/domain/usecases/get_books.dart';
import '../../features/bible_reader/domain/usecases/get_chapter_count.dart';
import '../../features/bible_reader/domain/usecases/search_verses.dart';
import '../../features/bible_reader/presentation/cubit/bible_reader_cubit.dart';
import '../../features/bible_reader/presentation/cubit/version_selector_cubit.dart';
import '../../features/bible_reader/presentation/cubit/library_cubit.dart';
import '../../features/bible_reader/presentation/cubit/search_cubit.dart';
import '../../features/bible_reader/presentation/cubit/theme_cubit.dart';
import '../../features/bible_reader/presentation/cubit/bookmarks_cubit.dart';
import '../../features/bible_reader/presentation/cubit/locale_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/reading_plans/data/repositories/reading_plan_repository_impl.dart';
import '../../features/reading_plans/domain/repositories/i_reading_plan_repository.dart';
import '../../features/reading_plans/presentation/cubit/reading_plan_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/local_storage.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core Services ────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage(sl()));

  // ── Data sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<BibleLocalDataSource>(
    () => BibleLocalDataSource(),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<IBibleRepository>(
    () => BibleRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<IReadingPlanRepository>(
    () => ReadingPlanRepositoryImpl(sl()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetBibleVersions(sl()));
  sl.registerLazySingleton(() => GetVerses(sl()));
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => GetChapterCount(sl()));
  sl.registerLazySingleton(() => SearchVerses(sl()));

  // ── Cubits (factory — new instance each time) ─────────────────────────────
  sl.registerFactory(() => BibleReaderCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => VersionSelectorCubit(sl()));
  sl.registerFactory(() => LibraryCubit(sl()));
  sl.registerFactory(() => SearchCubit(sl()));
  sl.registerFactory(() => BookmarksCubit(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AuthCubit(sl()));
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => LocaleCubit(sl()));
  sl.registerLazySingleton(() => OnboardingCubit(sl()));
  sl.registerFactory(() => ReadingPlanCubit(sl()));
}


