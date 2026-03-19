import '../../domain/entities/verse.dart';

class VerseModel extends Verse {
  const VerseModel({
    required super.number,
    required super.text,
    required super.bookName,
    required super.chapter,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      number: json['number'] as int,
      text: json['text'] as String,
      bookName: json['bookName'] as String,
      chapter: json['chapter'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'text': text,
        'bookName': bookName,
        'chapter': chapter,
      };
}
