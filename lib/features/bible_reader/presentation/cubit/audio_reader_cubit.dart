import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/services/audio_streaming_service.dart';
import '../../../../core/services/bible_brain_service.dart';
import '../../domain/entities/verse_timing.dart';

part 'audio_reader_state.dart';

class AudioReaderCubit extends Cubit<AudioReaderState> {
  final AudioStreamingService _audioService;
  final BibleBrainService _bibleBrainService;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  AudioReaderCubit(this._audioService, this._bibleBrainService) : super(const AudioReaderInitial()) {
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  Future<void> loadChapter({
    required String bookId,
    required int chapter,
    String? filesetId, // Optional, can be determined by service
  }) async {
    emit(AudioReaderLoading(
      bookId: bookId,
      chapter: chapter,
      audioUrl: '',
      timings: const [],
    ));

    try {
      // Determine filesetId for AMHNIV (New Amharic Standard)
      // OT: AMHBIBO1DA (Book 1-39), NT: AMHBIBN1DA (Book 40-66)
      final bookNum = int.tryParse(bookId) ?? 1;
      final defaultFilesetId = bookNum <= 39 ? 'AMHBIBO1DA' : 'AMHBIBN1DA';
      final effectiveFilesetId = filesetId ?? defaultFilesetId;

      // 1. Fetch real audio URL from Bible Brain
      final audioUrl = await _bibleBrainService.getAudioUrl(
        filesetId: effectiveFilesetId,
        bookId: bookId,
        chapter: chapter,
      );

      // 2. Fetch verse timings from Bible Brain
      final timings = await _bibleBrainService.getVerseTimings(
        filesetId: effectiveFilesetId,
        bookId: bookId,
        chapter: chapter,
      );

      await _audioService.setUrl(audioUrl);
      
      _positionSubscription?.cancel();
      _positionSubscription = _audioService.positionStream.listen((position) {
        if (timings.isEmpty) return;
        
        final activeVerse = timings.lastWhere(
          (t) => t.startTime <= position,
          orElse: () => timings.first,
        );
        
        if (state is AudioReaderLoaded) {
          final current = state as AudioReaderLoaded;
          if (current.activeVerseNumber != activeVerse.verseNumber) {
            emit(current.copyWith(activeVerseNumber: activeVerse.verseNumber));
          }
        }
      });

      emit(AudioReaderLoaded(
        bookId: bookId,
        chapter: chapter,
        audioUrl: audioUrl,
        timings: timings,
        isPlaying: false,
      ));
    } catch (e) {
      emit(AudioReaderError(e.toString()));
    }
  }

  void play() {
    if (state is AudioReaderLoaded) {
      _audioService.play();
      emit((state as AudioReaderLoaded).copyWith(isPlaying: true));
    }
  }

  void pause() {
    if (state is AudioReaderLoaded) {
      _audioService.pause();
      emit((state as AudioReaderLoaded).copyWith(isPlaying: false));
    }
  }

  void stop() {
    _audioService.stop();
    if (state is AudioReaderLoaded) {
      emit((state as AudioReaderLoaded).copyWith(isPlaying: false, activeVerseNumber: 1));
    }
  }

  void seekToVerse(int verseNumber) {
    if (state is AudioReaderLoaded) {
      final loadedState = state as AudioReaderLoaded;
      final timing = loadedState.timings.firstWhere((t) => t.verseNumber == verseNumber);
      _audioService.seek(timing.startTime);
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    return super.close();
  }
}
