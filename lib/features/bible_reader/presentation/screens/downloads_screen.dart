import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.audioRecordings,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // --- Storage Usage Card ---
                _StorageUsageCard(),

                const SizedBox(height: 32),
                // --- Downloading Section ---
                Text(
                  l10n.downloading,
                  style: tt.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                const SizedBox(height: 16),
                _ActiveDownloadCard(),

                const SizedBox(height: 32),
                // --- Downloaded Content ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.downloadedBooks,
                      style: tt.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                      label: Text(
                        l10n.clearAll,
                        style: TextStyle(fontSize: 12, fontFamily: 'Noto Serif Ethiopic'),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _DownloadedItem(
                  title: 'ቅዱስ መጽሐፍ (1962 እትም)',
                  subtitle: '8.4 MB • ሙሉ ይዘት',
                  icon: Icons.book_rounded,
                ),
                _DownloadedItem(
                  title: 'የመዝሙረ ዳዊት ትርጓሜ',
                  subtitle: '12.1 MB • ትርጓሜ',
                  icon: Icons.auto_stories_rounded,
                ),
                _DownloadedItem(
                  title: 'መጽሐፈ ሲራክ',
                  subtitle: '3.2 MB • ግዕዝ እና አማርኛ',
                  icon: Icons.menu_book_rounded,
                  isLast: true,
                ),
                const SizedBox(height: 120), // Bottom padding for CTA
              ],
            ),
          ),

          // --- Bottom CTA ---
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: _BottomCTA(),
          ),
        ],
      ),
    );
  }
}

class _StorageUsageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.storageUsage,
            style: tt.labelLarge!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '1.2 GB',
                style: tt.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.usedOutOf('5.0 GB'),
                style: tt.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'Noto Serif Ethiopic',
                ),
              ),
              const Spacer(),
              Icon(Icons.menu_rounded, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          // Multi-color Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: 24, child: Container(color: theme.colorScheme.primary)),
                  Expanded(flex: 12, child: Container(color: Colors.amber.withValues(alpha: 0.5))),
                  Expanded(flex: 64, child: Container(color: theme.colorScheme.surfaceContainerHighest)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendItem(label: l10n.booksLegend, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              _LegendItem(label: l10n.audioLegend, color: Colors.amber.withValues(alpha: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
      ],
    );
  }
}

class _ActiveDownloadCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.play_circle_outline_rounded, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'የዮሐንስ ወንጌል - ትርጓሜ',
                      style: tt.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Noto Serif Ethiopic'),
                    ),
                    Text(
                      'አዲስ • 45.2 MB',
                      style: tt.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant, fontFamily: 'Noto Serif Ethiopic'),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.close_rounded, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 4,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '65%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '2.4 MB/S',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DownloadedItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLast;

  const _DownloadedItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Noto Serif Ethiopic'),
                ),
                Text(
                  subtitle,
                  style: tt.bodySmall!.copyWith(color: theme.colorScheme.onSurfaceVariant, fontFamily: 'Noto Serif Ethiopic'),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: 84,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.downloadMoreTitle,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Noto Serif Ethiopic',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.downloadMoreSubtitle,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontFamily: 'Noto Serif Ethiopic',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add_rounded, color: theme.colorScheme.onPrimary, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
