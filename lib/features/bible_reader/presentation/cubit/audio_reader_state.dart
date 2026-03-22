part of 'audio_reader_cubit.dart';

abstract class AudioReaderState extends Equatable {
  const AudioReaderState();

  @override
  List<Object?> get props => [];
}

class AudioReaderInitial extends AudioReaderState {
  const AudioReaderInitial();
}

class AudioReaderLoading extends AudioReaderState {
  final String bookId;
  final int chapter;
  final String audioUrl;
  final List<VerseTiming> timings;

  const AudioReaderLoading({
    required this.bookId,
    required this.chapter,
    required this.audioUrl,
    required this.timings,
  });

  @override
  List<Object?> get props => [bookId, chapter, audioUrl, timings];
}

class AudioReaderLoaded extends AudioReaderState {
  final String bookId;
  final int chapter;
  final String audioUrl;
  final List<VerseTiming> timings;
  final bool isPlaying;
  final int? activeVerseNumber;

  const AudioReaderLoaded({
    required this.bookId,
    required this.chapter,
    required this.audioUrl,
    required this.timings,
    required this.isPlaying,
    this.activeVerseNumber,
  });

  AudioReaderLoaded copyWith({
    bool? isPlaying,
    int? activeVerseNumber,
  }) {
    return AudioReaderLoaded(
      bookId: bookId,
      chapter: chapter,
      audioUrl: audioUrl,
      timings: timings,
      isPlaying: isPlaying ?? this.isPlaying,
      activeVerseNumber: activeVerseNumber ?? this.activeVerseNumber,
    );
  }

  @override
  List<Object?> get props => [bookId, chapter, audioUrl, timings, isPlaying, activeVerseNumber];
}

class AudioReaderError extends AudioReaderState {
  final String message;
  const AudioReaderError(this.message);

  @override
  List<Object?> get props => [message];
}
