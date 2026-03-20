import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.name,
    required super.englishName,
    required super.chapterCount,
  });

  factory BookModel.fromJson(Map<String, dynamic> json, String englishName) {
    final chapters = json['chapters'] as List;
    return BookModel(
      id: json['book_id'].toString(),
      name: json['book_name'] as String,
      englishName: englishName,
      chapterCount: chapters.length,
    );
  }

  Map<String, dynamic> toJson() => {
        'book_id': id,
        'book_name': name,
        'chapter_count': chapterCount,
      };
}
