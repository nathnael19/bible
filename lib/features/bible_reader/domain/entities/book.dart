import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String name;
  final int chapterCount;

  const Book({
    required this.id,
    required this.name,
    required this.chapterCount,
  });

  @override
  List<Object?> get props => [id, name, chapterCount];
}
