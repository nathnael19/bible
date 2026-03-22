import '../../domain/entities/verse.dart';
import 'package:flutter/material.dart';

/// A single verse widget. No dividers — spacing creates separation per DESIGN.md.
class VerseCard extends StatelessWidget {
  final Verse verse;
  final bool isActive;
  final bool isAudioActive;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final double fontSizeFactor;
  final bool isBookmarked;
  final Color? highlightColor;

  const VerseCard({
    super.key,
    required this.verse,
    this.isActive = false,
    this.isAudioActive = false,
    this.onTap,
    this.onDoubleTap,
    this.fontSizeFactor = 1.0,
    this.isBookmarked = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.surfaceContainerHigh
              : isAudioActive
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : highlightColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                )
              : isAudioActive
                  ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    )
                  : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Accent bar ─────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: (isActive || isAudioActive) ? 4 : 0,
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // ── Verse number ─────────────────
              SizedBox(
                width: 36,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${verse.number}',
                        style: tt.bodySmall!.copyWith(
                          fontSize: 13 * fontSizeFactor,
                          color: isAudioActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Serif Ethiopic',
                        ),
                      ),
                    ),
                    if (isBookmarked) ...[
                      const SizedBox(height: 4),
                      Icon(
                        Icons.bookmark_rounded,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // ── Verse text ────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    verse.text,
                    style: tt.bodyLarge!.copyWith(
                      height: 1.7,
                      fontSize: (tt.bodyLarge?.fontSize ?? 16) * fontSizeFactor,
                      color: isAudioActive
                          ? theme.colorScheme.onSurface
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
