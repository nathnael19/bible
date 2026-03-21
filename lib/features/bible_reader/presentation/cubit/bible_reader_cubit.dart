import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/usecases/get_verses.dart';
import '../../domain/usecases/get_chapter_count.dart';
import '../../domain/usecases/get_books.dart';
import 'package:bible/core/services/local_storage.dart';

// Helper for copyWith to distinguish between null and not passed
class Value<T> {
  final T value;
  const Value(this.value);
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class BibleReaderState extends Equatable {
  const BibleReaderState();
  @override
  List<Object?> get props => [];
}

class BibleReaderLoading extends BibleReaderState {
  const BibleReaderLoading();
}

class BibleReaderLoaded extends BibleReaderState {
  final String versionId;
  final List<Verse> verses;
  final String book;
  final String bookId;
  final int chapter;
  final int chapterCount;
  final int? activeVerseNumber;
  final Set<int> bookmarks;
  final Map<int, int> highlights; // Map<VerseNumber, ColorValue>

  const BibleReaderLoaded({
    required this.versionId,
    required this.verses,
    required this.book,
    required this.bookId,
    required this.chapter,
    required this.chapterCount,
    this.activeVerseNumber,
    this.bookmarks = const {},
    this.highlights = const {},
  });

  BibleReaderLoaded copyWith({
    String? versionId,
    List<Verse>? verses,
    String? book,
    String? bookId,
    int? chapter,
    int? chapterCount,
    Value<int?>? activeVerseNumber,
    Set<int>? bookmarks,
    Map<int, int>? highlights,
  }) =>
      BibleReaderLoaded(
        versionId: versionId ?? this.versionId,
        verses: verses ?? this.verses,
        book: book ?? this.book,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        chapterCount: chapterCount ?? this.chapterCount,
        activeVerseNumber: activeVerseNumber != null ? activeVerseNumber.value : this.activeVerseNumber,
        bookmarks: bookmarks ?? this.bookmarks,
        highlights: highlights ?? this.highlights,
      );

  @override
  List<Object?> get props => [
        versionId,
        verses,
        book,
        bookId,
        chapter,
        chapterCount,
        activeVerseNumber,
        bookmarks,
        highlights,
      ];
}

class BibleReaderError extends BibleReaderState {
  final String message;
  const BibleReaderError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class BibleReaderCubit extends Cubit<BibleReaderState> {
  final GetVerses _getVerses;
  final GetChapterCount _getChapterCount;
  final LocalStorage _storage;
  final GetBooks _getBooks;

  BibleReaderCubit(
    this._getVerses,
    this._getChapterCount,
    this._storage,
    this._getBooks,
  ) : super(const BibleReaderLoading());

  Future<void> loadVerses({
    String? versionId,
    required String book,
    required int chapter,
    String? bookId,
    int? targetVerse,
  }) async {
    final effectiveVersionId = versionId ?? 
      (state is BibleReaderLoaded ? (state as BibleReaderLoaded).versionId : 'amh_standard');
      
    emit(const BibleReaderLoading());
    try {
      final verses = await _getVerses(
        versionId: effectiveVersionId,
        book: book,
        chapter: chapter,
      );
      final chapterCount = await _getChapterCount(book, versionId: effectiveVersionId);
      // Fallback for default load
      String effectiveBookId = bookId ?? (book == 'ኦሪት ዘፍጥረት' || book == 'Genesis' ? '1' : '0');
      final bookmarks = _storage.getBookmarks(effectiveBookId, chapter);
      
      // Record reading event and stats
      _storage.recordReadingEvent(book, effectiveBookId, chapter);
      _storage.logActivity('chapter', {
        'bookId': effectiveBookId,
        'chapter': chapter,
        'versionId': effectiveVersionId,
      });
      _storage.incrementVersesRead(verses.length);

      // Save last read location
      _storage.saveLastReadLocation(book, effectiveBookId, chapter, versionId: effectiveVersionId);

      emit(BibleReaderLoaded(
        versionId: effectiveVersionId,
        verses: verses,
        book: book,
        bookId: effectiveBookId,
        chapter: chapter,
        chapterCount: chapterCount,
        activeVerseNumber: targetVerse,
        bookmarks: bookmarks,
      ));
    } catch (e) {
      emit(BibleReaderError(e.toString()));
    }
  }

  Future<void> loadInitialLocation() async {
    final lastRead = _storage.getLastReadLocation();
    if (lastRead != null) {
      await loadVerses(
        versionId: lastRead['versionId'] as String?,
        book: lastRead['book'] as String,
        bookId: lastRead['bookId'] as String,
        chapter: lastRead['chapter'] as int,
      );
    } else {
      await loadVerses(
        versionId: 'amh_standard',
        book: 'ኦሪት ዘፍጥረት',
        chapter: 1,
        bookId: '1',
      );
    }
  }

  void selectVerse(int? verseNumber) {
    if (state is BibleReaderLoaded) {
      emit((state as BibleReaderLoaded).copyWith(activeVerseNumber: Value(verseNumber)));
    }
  }


  void toggleBookmark(int verseNumber) {
    if (state is BibleReaderLoaded) {
      final loaded = state as BibleReaderLoaded;
      final newBookmarks = Set<int>.from(loaded.bookmarks);
      final newHighlights = Map<int, int>.from(loaded.highlights);

      if (newBookmarks.contains(verseNumber)) {
        newBookmarks.remove(verseNumber);
        newHighlights.remove(verseNumber);
      } else {
        newBookmarks.add(verseNumber);
        _storage.logActivity('bookmark', {
          'bookId': loaded.bookId,
          'chapter': loaded.chapter,
          'verse': verseNumber,
        });
        // Automatically highlight with a subtle version of the primary color
        // Assuming we are in a context where we can't easily get the theme here,
        // we'll use a standard gold/burgundy hex if needed, 
        // or just let the UI handle the default highlight if bookmarks exists?
        // Actually, better to keep highlights explicit. 
        // I'll use a standard subtle gold: 0x33FFD700
        newHighlights[verseNumber] = 0x33FFD700;
      }
      _storage.saveBookmarks(loaded.bookId, loaded.chapter, newBookmarks);
      emit(loaded.copyWith(
        bookmarks: newBookmarks,
        highlights: newHighlights,
        activeVerseNumber: const Value(null),
      ));
    }
  }

  Future<void> nextChapter() async {
    if (state is! BibleReaderLoaded) return;
    final currentState = state as BibleReaderLoaded;
    
    if (currentState.chapter < currentState.chapterCount) {
      await loadVerses(
        book: currentState.book,
        bookId: currentState.bookId,
        chapter: currentState.chapter + 1,
      );
    } else {
      final books = await _getBooks(versionId: currentState.versionId);
      final currentIndex = books.indexWhere((b) => b.id.toString() == currentState.bookId);
      if (currentIndex != -1 && currentIndex < books.length - 1) {
        final nextBook = books[currentIndex + 1];
        await loadVerses(
          versionId: currentState.versionId,
          book: nextBook.name,
          bookId: nextBook.id.toString(),
          chapter: 1,
        );
      }
    }
  }

  Future<void> previousChapter() async {
    if (state is! BibleReaderLoaded) return;
    final currentState = state as BibleReaderLoaded;
    
    if (currentState.chapter > 1) {
      await loadVerses(
        book: currentState.book,
        bookId: currentState.bookId,
        chapter: currentState.chapter - 1,
      );
    } else {
      final books = await _getBooks(versionId: currentState.versionId);
      final currentIndex = books.indexWhere((b) => b.id.toString() == currentState.bookId);
      if (currentIndex > 0) {
        final prevBook = books[currentIndex - 1];
        final prevBookChapterCount = await _getChapterCount(prevBook.name, versionId: currentState.versionId);
        await loadVerses(
          versionId: currentState.versionId,
          book: prevBook.name,
          bookId: prevBook.id.toString(),
          chapter: prevBookChapterCount,
        );
      }
    }
  }

  void setHighlight(int verseNumber, int? colorValue) {
    if (state is BibleReaderLoaded) {
      final loaded = state as BibleReaderLoaded;
      final newHighlights = Map<int, int>.from(loaded.highlights);
      if (colorValue == null) {
        newHighlights.remove(verseNumber);
      } else {
        newHighlights[verseNumber] = colorValue;
      }
      emit(loaded.copyWith(highlights: newHighlights));
    }
  }

  Future<void> loadBookChapter({
    required String book,
    required int chapter,
    String? bookId,
    String versionId = 'amh_standard',
    int? targetVerse,
  }) async {
    await loadVerses(
      versionId: versionId,
      book: book,
      chapter: chapter,
      bookId: bookId,
      targetVerse: targetVerse,
    );
  }

  void navigateToChapter(int chapter) {
    if (state is BibleReaderLoaded) {
      final loaded = state as BibleReaderLoaded;
      loadVerses(
        book: loaded.book,
        chapter: chapter,
        bookId: loaded.bookId,
      );
    }
  }
}
