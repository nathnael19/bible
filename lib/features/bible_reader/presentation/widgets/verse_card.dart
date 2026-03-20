import '../../domain/entities/verse.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// A single verse widget. No dividers — spacing creates separation per DESIGN.md.
class VerseCard extends StatelessWidget {
  final Verse verse;
  final bool isActive;
  final VoidCallback? onTap;

  const VerseCard({
    super.key,
    required this.verse,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 22), // 1.4rem ≈ 22px
        decoration: BoxDecoration(
          color: isActive
              ? SabaColors.surfaceContainerHigh
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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
                  color: SabaColors.primaryContainer,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${verse.number}',
                    style: tt.bodySmall!.copyWith(
                      fontSize: 13,
                      color: SabaColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Serif Ethiopic',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ── Verse text ────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    verse.text,
                    style: tt.bodyLarge!.copyWith(height: 1.7),
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
