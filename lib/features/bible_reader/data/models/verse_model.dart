import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  const VerseModel({
    required super.number,
    required super.text,
    required super.bookName,
    required super.bookId,
    required super.chapter,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      number: json['verse'] as int,
      text: json['text'] as String,
      bookName: json['book_name'] as String? ?? 'Unknown Book',
      bookId: json['book_id']?.toString() ?? '1',
      chapter: json['chapter'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'text': text,
        'bookName': bookName,
        'bookId': bookId,
        'chapter': chapter,
      };
}
