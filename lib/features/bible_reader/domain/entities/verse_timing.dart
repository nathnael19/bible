import 'package:equatable/equatable.dart';

class VerseTiming extends Equatable {
  final int verseNumber;
  final Duration startTime;
  final Duration endTime;

  const VerseTiming({
    required this.verseNumber,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [verseNumber, startTime, endTime];
}
