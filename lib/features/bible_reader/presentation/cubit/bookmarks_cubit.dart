import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/core/services/local_storage.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/verse.dart';
import '../../domain/usecases/get_verses.dart';
import '../../domain/usecases/get_books.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class BookmarksState extends Equatable {
  const BookmarksState();
  @override
  List<Object?> get props => [];
}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {
  final List<Bookmark> bookmarks;
  const BookmarksLoaded(this.bookmarks);
  @override
  List<Object?> get props => [bookmarks];
}

class BookmarksError extends BookmarksState {
  final String message;
  const BookmarksError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class BookmarksCubit extends Cubit<BookmarksState> {
  final LocalStorage _storage;
  final GetVerses _getVerses;
  final GetBooks _getBooks;

  BookmarksCubit(this._storage, this._getVerses, this._getBooks) : super(BookmarksLoading());

  Future<void> loadBookmarks() async {
    emit(BookmarksLoading());
    try {
      final bookmarkKeys = _storage.getAllBookmarksKeys();
      final List<Bookmark> allBookmarks = [];
      
      final List<Book> books = (await _getBooks()).cast<Book>();
      
      for (final entry in bookmarkKeys.entries) {
        // key format: bookmarks_{bookId}_{chapter}
        final keyParts = entry.key.split('_');
        if (keyParts.length < 3) continue;
        
        final bookId = keyParts[1];
        final chapter = int.tryParse(keyParts[2]) ?? 1;
        final verseNumbers = entry.value;

        final book = books.firstWhere(
          (b) => b.id == bookId,
          orElse: () => books.firstWhere((b) => b.name == bookId, orElse: () => books.first),
        );

        final List<Verse> verses = (await _getVerses(
          versionId: 'amh_standard',
          book: book.name,
          chapter: chapter,
        )).cast<Verse>();

        for (final verseNumber in verseNumbers) {
          final verse = verses.firstWhere(
            (v) => v.number == verseNumber,
            orElse: () => verses.first,
          );
          
          allBookmarks.add(Bookmark(
            bookId: bookId,
            bookName: book.name,
            chapter: chapter,
            verseNumber: verseNumber,
            text: verse.text,
          ));
        }
      }
      
      // Sort bookmarks? Maybe by book and chapter
      allBookmarks.sort((a, b) {
        final bookCompare = a.bookName.compareTo(b.bookName);
        if (bookCompare != 0) return bookCompare;
        final chapterCompare = a.chapter.compareTo(b.chapter);
        if (chapterCompare != 0) return chapterCompare;
        return a.verseNumber.compareTo(b.verseNumber);
      });

      emit(BookmarksLoaded(allBookmarks));
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }

  Future<void> removeBookmark(Bookmark bookmark) async {
    if (state is BookmarksLoaded) {
      final currentBookmarks = (state as BookmarksLoaded).bookmarks;
      final updatedBookmarks = currentBookmarks.where((b) => b != bookmark).toList();
      
      // Update storage
      final bookBookmarks = updatedBookmarks
          .where((b) => b.bookId == bookmark.bookId && b.chapter == bookmark.chapter)
          .map((b) => b.verseNumber)
          .toSet();
      
      await _storage.saveBookmarks(bookmark.bookId, bookmark.chapter, bookBookmarks);
      emit(BookmarksLoaded(updatedBookmarks));
    }
  }
}
