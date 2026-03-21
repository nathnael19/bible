import '../../domain/entities/verse.dart';
import 'package:flutter/material.dart';

/// A single verse widget. No dividers — spacing creates separation per DESIGN.md.
class VerseCard extends StatelessWidget {
  final Verse verse;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final double fontSizeFactor;
  final bool isBookmarked;
  final Color? highlightColor;

  const VerseCard({
    super.key,
    required this.verse,
    this.isActive = false,
    this.onTap,
    this.onDoubleTap,
    this.fontSizeFactor = 1.0,
    this.isBookmarked = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 0.0), // Reduced from 4
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ), // Reduced vertical from 12
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.surfaceContainerHigh
              : highlightColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                )
              : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 4px Burgundy accent bar (active only) ─────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 4 : 0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // ── Verse number (editorial large numeral) ─────────────────
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
                          color: Theme.of(context).colorScheme.secondary,
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
                        color: Theme.of(context).colorScheme.primary,
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
