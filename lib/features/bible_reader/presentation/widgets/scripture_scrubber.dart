import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// The "Scripture Scrubber" — horizontal chapter navigator per DESIGN.md.
/// Active chapter: full opacity display-sm. Adjacent: dimmed at 50%.
class ScriptureScrubber extends StatefulWidget {
  final int totalChapters;
  final int activeChapter;
  final ValueChanged<int> onChapterSelected;

  const ScriptureScrubber({
    super.key,
    required this.totalChapters,
    required this.activeChapter,
    required this.onChapterSelected,
  });

  @override
  State<ScriptureScrubber> createState() => _ScriptureScrubberState();
}

class _ScriptureScrubberState extends State<ScriptureScrubber> {
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
  }

  void _scrollToActive() {
    final offset = (widget.activeChapter - 1) * 56.0;
    if (_scroll.hasClients) {
      _scroll.animateTo(
        offset.clamp(0.0, _scroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: 64,
      child: ListView.builder(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        itemCount: widget.totalChapters,
        itemBuilder: (_, i) {
          final chapter = i + 1;
          final isActive = chapter == widget.activeChapter;
          final distance = (chapter - widget.activeChapter).abs();
          final opacity = isActive
              ? 1.0
              : (1.0 - (distance * 0.18)).clamp(0.25, 0.5);

          return GestureDetector(
            onTap: () => widget.onChapterSelected(chapter),
            child: Container(
              width: 48,
              alignment: Alignment.center,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: isActive
                    ? tt.displaySmall!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: SabaColors.primaryContainer,
                      )
                    : tt.bodyMedium!.copyWith(
                        color: SabaColors.onSurface.withValues(
                          alpha: opacity,
                        ),
                      ),
                child: Text('$chapter'),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }
}
