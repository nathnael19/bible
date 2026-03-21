import 'package:bible/l10n/app_localizations.dart';
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
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/bible_reader/presentation/screens/app_shell.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/bible_reader/presentation/cubit/locale_cubit.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          create: (_) => sl<BibleReaderCubit>()..loadInitialLocation(),
        ),
        BlocProvider(create: (_) => sl<SearchCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<BookmarksCubit>()..loadBookmarks()),
        BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
        BlocProvider(create: (_) => sl<OnboardingCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp(
                onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
                debugShowCheckedModeBanner: false,
                theme: SabaTheme.light(),
                darkTheme: SabaTheme.dark(),
                themeMode: mode,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: BlocBuilder<OnboardingCubit, bool>(
                  builder: (context, onboardingComplete) {
                    return BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state.status == AuthStatus.initial) {
                          return const SplashScreen();
                        }

                        // If onboarding is not complete, show onboarding
                        if (!onboardingComplete) {
                          return const OnboardingScreen();
                        }

                        if (state.status == AuthStatus.authenticated) {
                          return const AppShell();
                        }
                        return const LoginScreen();
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
