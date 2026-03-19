import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SabaColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 40, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Meglecha', style: tt.headlineMedium),
              Text(
                'ምስጋና • Profile',
                style: tt.bodySmall!.copyWith(
                  color: SabaColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // ── Avatar ────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SabaColors.primary,
                          SabaColors.primaryContainer,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'ÃŸ',
                        style: TextStyle(
                          color: SabaColors.onPrimary,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reader', style: tt.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Amharic Standard',
                        style: tt.bodySmall!.copyWith(
                          color: SabaColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // ── Reading Stats ─────────────────────────────────────────
              _SectionCard(
                title: 'Reading Stats',
                tt: tt,
                children: [
                  _StatRow(label: 'Days Streak', value: '7 days 🔥', tt: tt),
                  _StatRow(label: 'Chapters Read', value: '23', tt: tt),
                  _StatRow(label: 'Verses Bookmarked', value: '14', tt: tt),
                ],
              ),
              const SizedBox(height: 20),

              // ── Settings ───────────────────────────────────────────────
              _SectionCard(
                title: 'Settings',
                tt: tt,
                children: [
                  _SettingTile(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    value: 'አማርኛ',
                    tt: tt,
                  ),
                  _SettingTile(
                    icon: Icons.text_fields_outlined,
                    label: 'Font Size',
                    value: 'Medium',
                    tt: tt,
                  ),
                  _SettingTile(
                    icon: Icons.download_outlined,
                    label: 'Offline Versions',
                    value: '2 saved',
                    tt: tt,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Reading Mode Chips ─────────────────────────────────────
              Text('Reading Mode', style: tt.titleSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: const [
                  _ModeChip(label: 'Study Mode', isSelected: true),
                  _ModeChip(label: 'Devotional', isSelected: false),
                  _ModeChip(label: 'Night Mode', isSelected: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final TextTheme tt;
  const _SectionCard({
    required this.title,
    required this.children,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tt.titleSmall),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: SabaColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme tt;
  const _StatRow({required this.label, required this.value, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: tt.bodyMedium),
          Text(
            value,
            style: tt.bodyMedium!.copyWith(color: SabaColors.primaryContainer),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextTheme tt;
  const _SettingTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: SabaColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: tt.bodyMedium)),
          Text(
            value,
            style: tt.bodySmall!.copyWith(color: SabaColors.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right,
            size: 16,
            color: SabaColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _ModeChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
    );
  }
}
