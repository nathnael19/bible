import '../../domain/entities/bible_version.dart';

class BibleVersionModel extends BibleVersion {
  const BibleVersionModel({
    required super.id,
    required super.name,
    required super.language,
    required super.abbreviation,
  });

  factory BibleVersionModel.fromJson(Map<String, dynamic> json) {
    return BibleVersionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      abbreviation: json['abbreviation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'language': language,
        'abbreviation': abbreviation,
      };
}
