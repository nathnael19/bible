import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/bible_reader/presentation/cubit/bible_reader_cubit.dart';
import 'features/bible_reader/presentation/cubit/navigation_cubit.dart';
import 'features/bible_reader/presentation/cubit/library_cubit.dart';
import 'features/bible_reader/presentation/screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
              chapter: 1,
            ),
        ),
      ],
      child: MaterialApp(
        title: 'መጽሐፍ ቅዱስ — Ethiopian Bible',
        debugShowCheckedModeBanner: false,
        theme: SabaTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}
