import 'package:equatable/equatable.dart';

class Verse extends Equatable {
  final int number;
  final String text;
  final String bookName;
  final String bookId;
  final int chapter;

  const Verse({
    required this.number,
    required this.text,
    required this.bookName,
    required this.bookId,
    required this.chapter,
  });

  @override
  List<Object?> get props => [number, text, bookName, bookId, chapter];
}
