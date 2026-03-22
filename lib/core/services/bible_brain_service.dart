import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/bible_reader/domain/entities/verse_timing.dart';

class BibleBrainService {
  final http.Client _client;
  final String _apiKey;
  final String _baseUrl = 'https://api.biblebrain.com/v4';

  BibleBrainService({
    http.Client? client,
    String apiKey = 'YOUR_BIBLE_BRAIN_API_KEY', // Placeholder
  })  : _client = client ?? http.Client(),
        _apiKey = apiKey;

  /// Fetches the audio URL for a specific chapter.
  /// Note: In a real implementation, this would involve searching for the correct fileset.
  Future<String> getAudioUrl({
    required String filesetId,
    required String bookId,
    required int chapter,
  }) async {
    // Example endpoint: /bibles/filesets/{fileset_id}/{book_id}/{chapter}
    // For now, we return a mock URL if no API key is provided
    if (_apiKey == 'YOUR_BIBLE_BRAIN_API_KEY') {
      // Logic for AMHNIV as suggested by user
      // OT: AMHBIBO1DA, NT: AMHBIBN1DA
      return 'https://download.bible.audio/AMHNIV/$filesetId/$bookId/$chapter.mp3'; 
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/bibles/filesets/$filesetId/$bookId/$chapter?key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'][0]['path'];
    } else {
      throw Exception('Failed to fetch audio URL');
    }
  }

  /// Fetches verse-level timing data for a specific chapter.
  Future<List<VerseTiming>> getVerseTimings({
    required String filesetId,
    required String bookId,
    required int chapter,
  }) async {
    // Example endpoint for timing data
    // In a real scenario, this might be a separate fileset or included in metadata
    if (_apiKey == 'YOUR_BIBLE_BRAIN_API_KEY') {
      // Return mock timings for Genesis 1 (first few verses)
      return [
        VerseTiming(verseNumber: 1, startTime: Duration.zero, endTime: const Duration(seconds: 5)),
        VerseTiming(verseNumber: 2, startTime: const Duration(seconds: 5), endTime: const Duration(seconds: 15)),
        VerseTiming(verseNumber: 3, startTime: const Duration(seconds: 15), endTime: const Duration(seconds: 20)),
        // ... more mock data
      ];
    }

    final response = await _client.get(
      Uri.parse('$_baseUrl/bibles/filesets/$filesetId/$bookId/$chapter/timing?key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> timingsJson = data['data'];
      return timingsJson.map((json) {
        return VerseTiming(
          verseNumber: int.parse(json['verse_start']),
          startTime: Duration(milliseconds: (double.parse(json['seconds_start']) * 1000).toInt()),
          endTime: Duration(milliseconds: (double.parse(json['seconds_end']) * 1000).toInt()),
        );
      }).toList();
    } else {
       // Fallback to basic timings if not available
       return [];
    }
  }
}
