import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/local_storage.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/bookmarks_cubit.dart';
import '../cubit/locale_cubit.dart';
import '../cubit/navigation_cubit.dart';
import 'downloads_screen.dart';
import 'bookmarked_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<LocaleCubit>().state;
    final tt = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          l10n.appTitle,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // --- Avatar Section ---
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final initial = (state.username?.isNotEmpty == true) 
                    ? state.username!.trim().substring(0, 1).toUpperCase() 
                    : '?';
                return Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            width: 4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        color: theme.colorScheme.onPrimary,
                        size: 14,
                      ),
                    ),
                  ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      state.username ?? l10n.usernamePlaceholder,
                      style: tt.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                    Text(
                      '${state.username?.toLowerCase().replaceAll(' ', '.')}@example.com',
                      style: tt.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(label: l10n.profileDash, isActive: true, onTap: () {}),
                const SizedBox(width: 12),
                _ActionButton(label: l10n.share, isActive: false, onTap: () {}),
              ],
            ),

            const SizedBox(height: 32),

            // --- Streak Card ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.whatshot,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${sl.get<LocalStorage>().calculateStreak()}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      l10n.streakDays,
                      style: tt.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Grid Stats ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.menu_book_rounded,
                      value: '${sl.get<LocalStorage>().getTotalVersesRead()}',
                      label: l10n.versesRead,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocBuilder<BookmarksCubit, BookmarksState>(
                      builder: (context, state) {
                        final count = state is BookmarksLoaded
                            ? state.bookmarks.length
                            : 0;
                        return _InfoCard(
                          icon: Icons.bookmarks_rounded,
                          value: '$count',
                          label: l10n.bookmarks,
                          color: Colors.orange,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Level Progress ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _LevelCard(),
            ),

            const SizedBox(height: 32),

            // --- Settings Menus ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountAndPreferences,
                    style: tt.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Serif Ethiopic',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(
                            alpha: 0.03,
                          ),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.note_alt_outlined,
                          label: l10n.myArchives,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const DownloadsScreen()));
                          },
                        ),
                        _MenuTile(
                          icon: Icons.bookmark_outline,
                          label: l10n.bookmarkedChapters,
                          onTap: () {
                            context.read<BookmarksCubit>().loadBookmarks();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BookmarkedScreen(),
                              ),
                            );
                          },
                        ),
                        _MenuTile(
                          icon: Icons.history,
                          label: l10n.lastRead,
                          subLabel:
                              '${sl.get<LocalStorage>().getLastReadBook() ?? l10n.notReadYet} ${l10n.chapter} ${sl.get<LocalStorage>().getLastReadChapter()}',
                          isLast: true,
                          onTap: () {
                            context.read<NavigationCubit>().setTab(2);
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(
                            alpha: 0.03,
                          ),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _MenuTile(
                          icon: Icons.audiotrack_rounded,
                          label: l10n.audioRecordings,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DownloadsScreen(),
                            ),
                          ),
                        ),
                        _MenuTile(
                          icon: Icons.settings_outlined,
                          label: l10n.appSettings,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings Coming Soon')));
                          },
                        ),
                        _MenuTile(
                          icon: Icons.language_outlined,
                          label: l10n.language,
                          subLabel: locale.languageCode == 'am'
                              ? l10n.amharic
                              : l10n.english,
                          isLast: true,
                          onTap: () => _showLanguagePicker(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Logout ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout_outlined, size: 20),
                label: Text(
                  l10n.logout,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.02,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, currentLocale) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Serif Ethiopic',
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LanguageOption(
                    label: l10n.amharic,
                    isSelected: currentLocale.languageCode == 'am',
                    onTap: () {
                      context.read<LocaleCubit>().setLocale(const Locale('am'));
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  _LanguageOption(
                    label: l10n.english,
                    isSelected: currentLocale.languageCode == 'en',
                    onTap: () {
                      context.read<LocaleCubit>().setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _ActionButton({required this.label, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? null
              : Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
                ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _InfoCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.05 : 1.0,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Dynamic Level Calculation
    final totalVerses = sl.get<LocalStorage>().getTotalVersesRead();
    final level = (totalVerses ~/ 100) + 1; // Level up every 100 verses
    final progress = (totalVerses % 100) / 100.0;
    final percentage = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                 child: Text(
                  '${l10n.levelTitle.toUpperCase()} $level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
                  Text(
                    l10n.growthLevel,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFD700),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final bool isLast;
  final VoidCallback? onTap;
  const _MenuTile({
    required this.icon,
    required this.label,
    this.subLabel,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          subtitle: subLabel != null
              ? Text(
                  subLabel!,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
          trailing: Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            size: 20,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : null,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
