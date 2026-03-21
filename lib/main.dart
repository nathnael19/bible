import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/bible_reader/presentation/cubit/bible_reader_cubit.dart';
import 'features/bible_reader/presentation/cubit/navigation_cubit.dart';
import 'features/bible_reader/presentation/cubit/library_cubit.dart';
import 'features/bible_reader/presentation/cubit/search_cubit.dart';
import 'features/bible_reader/presentation/cubit/theme_cubit.dart';
import 'features/bible_reader/presentation/cubit/bookmarks_cubit.dart';


import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initDependencies();
  runApp(const BibleApp());
}


class BibleApp extends StatelessWidget {
  const BibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => sl<LibraryCubit>()..loadBooks()),
        BlocProvider(
          create: (_) => sl<BibleReaderCubit>()
            ..loadVerses(
              versionId: 'amh_standard',
              book: 'ኦሪት ዘፍጥረት',
              bookId: '1',
              chapter: 1,
            ),
        ),
        BlocProvider(create: (_) => sl<SearchCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<BookmarksCubit>()..loadBookmarks()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            title: 'መጽሐፍ ቅዱስ — Ethiopian Bible',
            debugShowCheckedModeBanner: false,
            theme: SabaTheme.light(),
            darkTheme: SabaTheme.dark(),
            themeMode: mode,
            home: const SplashScreen(),
          );

        },
      ),
    );
  }
}
