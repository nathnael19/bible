import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// The "Scripture Scrubber" redesigned to match the burgundy Ge'ez navigation.
class ScriptureScrubber extends StatelessWidget {
  final int totalItems;
  final int activeIndex;
  final ValueChanged<int> onItemSelected;
  final bool isChapterMode;

  const ScriptureScrubber({
    super.key,
    required this.totalItems,
    required this.activeIndex,
    required this.onItemSelected,
    this.isChapterMode = false,
  });

  String _toGeez(int n) {
    const geez = ['፩', '፪', '፫', '፬', '፭', '፮', '፯', '፰', '፱', '፲'];
    if (n >= 1 && n <= 10) return geez[n - 1];
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2 - 40),
              itemCount: totalItems,
              itemBuilder: (_, i) {
                final index = i + 1;
                final isActive = index == activeIndex;

                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isActive ? SabaColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: SabaColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _toGeez(index),
                      style: tt.headlineSmall!.copyWith(
                        color: isActive ? Colors.white : SabaColors.onSurfaceVariant.withValues(alpha: 0.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isChapterMode ? 'ምዕራፍ ይምረጡ' : 'ቁጥር ይምረጡ',
            style: tt.labelSmall!.copyWith(
              color: SabaColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ምዕራፍ ወይም ቁጥር ለመቀየር ይንኩ',
            style: tt.labelSmall!.copyWith(
              color: SabaColors.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
