import 'package:equatable/equatable.dart';

class BibleVersion extends Equatable {
  final String id;
  final String name;
  final String language;
  final String abbreviation;

  const BibleVersion({
    required this.id,
    required this.name,
    required this.language,
    required this.abbreviation,
  });

  @override
  List<Object?> get props => [id, name, language, abbreviation];
}
