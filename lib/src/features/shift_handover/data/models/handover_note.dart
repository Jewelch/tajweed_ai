import 'package:equatable/equatable.dart';

import '../../../../base/helpers/timestamp_helper.dart';

base class HandoverNote extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;
  final String authorId;
  final bool isAcknowledged;

  bool get isEmpty => text.isEmpty;

  const HandoverNote._({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.authorId,
    required this.isAcknowledged,
  });

  factory HandoverNote.acknowledged(HandoverNote note) => note.copyWith(isAcknowledged: true);

  factory HandoverNote.from(Map<String, dynamic> json) => HandoverNote._(
    id: json['id'] ?? '',
    text: json['text'] ?? '',
    timestamp: TimestampHelper.parseTimestamp(json['timestamp']),
    authorId: json['authorId'] ?? '',
    isAcknowledged: json['isAcknowledged'] ?? false,
  );

  HandoverNote copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    String? authorId,
    List<String>? taggedResidentIds,
    bool? isAcknowledged,
  }) => HandoverNote._(
    id: id ?? this.id,
    text: text ?? this.text,
    timestamp: timestamp ?? this.timestamp,
    authorId: authorId ?? this.authorId,
    isAcknowledged: isAcknowledged ?? this.isAcknowledged,
  );

  @override
  List<Object?> get props => [id, text, timestamp, authorId, isAcknowledged, isEmpty];
}
