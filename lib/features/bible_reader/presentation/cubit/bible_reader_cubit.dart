import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/verse.dart';
import '../../domain/usecases/get_verses.dart';

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
  final int chapter;
  final int? activeVerseNumber;

  const BibleReaderLoaded({
    required this.verses,
    required this.book,
    required this.chapter,
    this.activeVerseNumber,
  });

  BibleReaderLoaded copyWith({
    List<Verse>? verses,
    String? book,
    int? chapter,
    int? activeVerseNumber,
  }) =>
      BibleReaderLoaded(
        verses: verses ?? this.verses,
        book: book ?? this.book,
        chapter: chapter ?? this.chapter,
        activeVerseNumber: activeVerseNumber ?? this.activeVerseNumber,
      );

  @override
  List<Object?> get props => [verses, book, chapter, activeVerseNumber];
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

  BibleReaderCubit(this._getVerses) : super(const BibleReaderLoading());

  Future<void> loadVerses({
    String versionId = 'amh_standard',
    String book = 'ዘፍጥረት',
    int chapter = 1,
  }) async {
    emit(const BibleReaderLoading());
    try {
      final verses = await _getVerses(
        versionId: versionId,
        book: book,
        chapter: chapter,
      );
      emit(BibleReaderLoaded(verses: verses, book: book, chapter: chapter));
    } catch (e) {
      emit(BibleReaderError(e.toString()));
    }
  }

  void selectVerse(int verseNumber) {
    if (state is BibleReaderLoaded) {
      emit((state as BibleReaderLoaded).copyWith(activeVerseNumber: verseNumber));
    }
  }

  void navigateToChapter(int chapter) {
    if (state is BibleReaderLoaded) {
      final loaded = state as BibleReaderLoaded;
      loadVerses(book: loaded.book, chapter: chapter);
    }
  }
}
