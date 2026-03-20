import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String name;
  final String englishName;
  final int chapterCount;

  const Book({
    required this.id,
    required this.name,
    required this.englishName,
    required this.chapterCount,
  });

  @override
  List<Object?> get props => [id, name, englishName, chapterCount];
}
