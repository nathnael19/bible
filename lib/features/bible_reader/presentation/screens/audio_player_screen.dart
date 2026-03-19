import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _isPlaying = false;
  double _progress = 0.3;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SabaColors.surfaceContainerLow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 40, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Audio Bible', style: tt.headlineMedium),
              const SizedBox(height: 4),
              Text('ያደምጡ • Listen',
                  style: tt.bodySmall!
                      .copyWith(color: SabaColors.onSurfaceVariant)),
              const SizedBox(height: 40),

              // ── Album art ──────────────────────────────────────────────
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SabaColors.primary,
                        SabaColors.primaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: SabaColors.onSurfaceVariant
                            .withValues(alpha: 0.06),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book,
                        color: SabaColors.secondaryContainer, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Book / Chapter info ────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text('ዘፍጥረት • Genesis',
                        style: tt.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Chapter 1 • Amharic Standard',
                        style: tt.bodySmall!
                            .copyWith(color: SabaColors.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Progress ───────────────────────────────────────────────
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: SabaColors.primaryContainer,
                  inactiveTrackColor: SabaColors.surfaceContainerHighest,
                  thumbColor: SabaColors.primary,
                  overlayColor:
                      SabaColors.primary.withValues(alpha: 0.1),
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _progress,
                  onChanged: (v) => setState(() => _progress = v),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1:32',
                        style: tt.labelSmall!.copyWith(
                            color: SabaColors.onSurfaceVariant)),
                    Text('5:14',
                        style: tt.labelSmall!.copyWith(
                            color: SabaColors.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Controls ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: 36,
                    color: SabaColors.onSurfaceVariant,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SabaColors.primary,
                            SabaColors.primaryContainer,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: SabaColors.onPrimary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: 36,
                    color: SabaColors.onSurfaceVariant,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
