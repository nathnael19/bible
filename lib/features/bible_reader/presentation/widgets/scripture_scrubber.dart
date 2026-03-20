import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// The "Scripture Scrubber" with horizontal auto-centering for the active item.
class ScriptureScrubber extends StatefulWidget {
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

  @override
  State<ScriptureScrubber> createState() => _ScriptureScrubberState();
}

class _ScriptureScrubberState extends State<ScriptureScrubber> {
  late ScrollController _scrollController;
  final double _itemWidth = 90.0; // item width (70) + horizontal margin (10*2)

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive(animate: false));
  }

  @override
  void didUpdateWidget(covariant ScriptureScrubber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      _scrollToActive();
    }
  }

  void _scrollToActive({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;
    // index is 1-based
    final targetOffset = ((widget.activeIndex - 1) * _itemWidth + (_itemWidth / 2)) - (screenWidth / 2);
    final clampedOffset = targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent);

    if (animate) {
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  String _toGeez(int n) {
    const geez = ['፩', '፪', '፫', '፬', '፭', '፮', '፯', '፰', '፱', '፲'];
    if (n >= 1 && n <= 10) return geez[n - 1];
    return n.toString();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100, // Increased height for larger box
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2 - (_itemWidth / 2)),
              itemCount: widget.totalItems,
              itemBuilder: (_, i) {
                final index = i + 1;
                final isActive = index == widget.activeIndex;

                return GestureDetector(
                  onTap: () => widget.onItemSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 70, // Increased width
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isActive ? SabaColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: SabaColors.primary.withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _toGeez(index),
                      style: tt.headlineMedium!.copyWith(
                        fontSize: isActive ? 32 : 24, // Contrast size
                        color: isActive ? Colors.white : SabaColors.onSurfaceVariant.withValues(alpha: 0.3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isChapterMode ? 'ምዕራፍ ይምረጡ' : 'ቁጥር ይምረጡ',
            style: tt.labelMedium!.copyWith(
              color: SabaColors.primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Serif Ethiopic',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ምዕራፍ ወይም ቁጥር ለመቀየር ይንኩ',
            style: tt.labelSmall!.copyWith(
              color: SabaColors.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 11,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
        ],
      ),
    );
  }
}
