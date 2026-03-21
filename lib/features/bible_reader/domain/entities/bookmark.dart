import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String bookId;
  final String bookName;
  final int chapter;
  final int verseNumber;
  final String text;

  const Bookmark({
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.verseNumber,
    required this.text,
  });

  @override
  List<Object?> get props => [bookId, bookName, chapter, verseNumber, text];
}
