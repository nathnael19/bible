import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/usecases/get_verses.dart';
import '../../domain/usecases/get_chapter_count.dart';
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
  final List<Verse> verses;
  final String book;
  final String bookId;
  final int chapter;
  final int chapterCount;
  final int? activeVerseNumber;
  final Set<int> bookmarks;
  final Map<int, int> highlights; // Map<VerseNumber, ColorValue>

  const BibleReaderLoaded({
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

  BibleReaderCubit(this._getVerses, this._getChapterCount, this._storage) : super(const BibleReaderLoading());

  Future<void> loadVerses({
    String versionId = 'amh_standard',
    required String book,
    required int chapter,
    String? bookId,
    int? targetVerse,
  }) async {
    emit(const BibleReaderLoading());
    try {
      final verses = await _getVerses(
        versionId: versionId,
        book: book,
        chapter: chapter,
      );
      final chapterCount = await _getChapterCount(book);
      // Fallback for default load
      String effectiveBookId = bookId ?? (book == 'ኦሪት ዘፍጥረት' ? '1' : '0');
      final bookmarks = _storage.getBookmarks(effectiveBookId, chapter);
      
      // Record reading event and stats
      _storage.recordReadingEvent(book, chapter);
      _storage.incrementVersesRead(verses.length);

      emit(BibleReaderLoaded(
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
