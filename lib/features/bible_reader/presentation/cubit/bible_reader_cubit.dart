import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/usecases/get_verses.dart';

import '../../domain/usecases/get_chapter_count.dart';

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

  const BibleReaderLoaded({
    required this.verses,
    required this.book,
    required this.bookId,
    required this.chapter,
    required this.chapterCount,
    this.activeVerseNumber,
  });

  BibleReaderLoaded copyWith({
    List<Verse>? verses,
    String? book,
    String? bookId,
    int? chapter,
    int? chapterCount,
    int? activeVerseNumber,
  }) =>
      BibleReaderLoaded(
        verses: verses ?? this.verses,
        book: book ?? this.book,
        bookId: bookId ?? this.bookId,
        chapter: chapter ?? this.chapter,
        chapterCount: chapterCount ?? this.chapterCount,
        activeVerseNumber: activeVerseNumber ?? this.activeVerseNumber,
      );

  @override
  List<Object?> get props => [verses, book, bookId, chapter, chapterCount, activeVerseNumber];
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

  BibleReaderCubit(this._getVerses, this._getChapterCount) : super(const BibleReaderLoading());

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
      emit(BibleReaderLoaded(
        verses: verses,
        book: book,
        bookId: effectiveBookId,
        chapter: chapter,
        chapterCount: chapterCount,
        activeVerseNumber: targetVerse ?? 1,
      ));
    } catch (e) {
      emit(BibleReaderError(e.toString()));
    }
  }

  void selectVerse(int verseNumber) {
    if (state is BibleReaderLoaded) {
      emit((state as BibleReaderLoaded).copyWith(activeVerseNumber: verseNumber));
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
