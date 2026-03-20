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
  final double _itemWidth = 70.0; // width (70) + horizontal margin (10*2)

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Use a small delay to ensure the list is ready
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _scrollToActive(animate: false);
    });
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

    // With side padding centered on the first item, the scroll offset
    // needed to center any item 'i' is simply (i * itemWidth).
    final targetOffset = (widget.activeIndex - 1) * _itemWidth;
    final clampedOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

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


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // Side padding keeps the first and last items centerable
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width / 2 -
                    (_itemWidth / 2) +
                    20,
              ),
              itemCount: widget.totalItems,
              itemBuilder: (_, i) {
                final index = i + 1;
                final isActive = index == widget.activeIndex;

                return GestureDetector(
                  onTap: () => widget.onItemSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isActive ? SabaColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: SabaColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      index.toString(),
                      style: tt.headlineMedium!.copyWith(
                        fontSize: isActive ? 28 : 20,
                        color: isActive
                            ? Colors.white
                            : SabaColors.onSurfaceVariant.withValues(
                                alpha: 0.3,
                              ),
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
