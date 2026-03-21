import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmarks_cubit.dart';
import '../cubit/bible_reader_cubit.dart';
import '../cubit/navigation_cubit.dart';
import '../../domain/entities/bookmark.dart';

class BookmarkedScreen extends StatelessWidget {
  const BookmarkedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('ምዕራፍ የተደረገባቸው'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<BookmarksCubit, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookmarksError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BookmarksLoaded) {
            final bookmarks = state.bookmarks;
            if (bookmarks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 64,
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ምንም የተቀመጡ ጥቅሶች የሉም',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: 'Noto Serif Ethiopic',
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return _BookmarkCard(bookmark: bookmark);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  const _BookmarkCard({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key('bookmark_${bookmark.bookId}_${bookmark.chapter}_${bookmark.verseNumber}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.error),
      ),
      onDismissed: (_) {
        context.read<BookmarksCubit>().removeBookmark(bookmark);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        color: theme.colorScheme.surfaceContainerLow,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // 1. Load the book/chapter and highlight the verse
            context.read<BibleReaderCubit>().loadBookChapter(
              book: bookmark.bookName,
              chapter: bookmark.chapter,
              bookId: bookmark.bookId,
              targetVerse: bookmark.verseNumber,
            );
            
            // 2. Switch to Reader Tab (Index 2)
            context.read<NavigationCubit>().setTab(2);
            
            // 3. Close this screen
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${bookmark.bookName} ${bookmark.chapter}:${bookmark.verseNumber}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Serif Ethiopic',
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bookmark_rounded,
                      size: 18,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  bookmark.text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
