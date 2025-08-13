import 'package:generic_requester/generic_requester.dart';

import 'handover_note.dart';

final class ShiftReportDATO extends ModelingProtocol {
  final String id;
  final String caregiverId;
  final String startTime;
  final String endTime;
  final List<HandoverNote> notes;
  final String summary;
  final bool? isSubmitted;

  const ShiftReportDATO({
    required this.id,
    required this.caregiverId,
    required this.startTime,
    required this.endTime,
    required this.summary,
    required this.isSubmitted,
    required this.notes,
  });

  factory ShiftReportDATO.empty() => const ShiftReportDATO(
    id: '',
    caregiverId: '',
    startTime: '',
    endTime: '',
    summary: '',
    isSubmitted: false,
    notes: [],
  );

  @override
  ShiftReportDATO fromJson(json) {
    try {
      return ShiftReportDATO(
        id: json?['id'] ?? '',
        caregiverId: json?['caregiverId'] ?? '',
        startTime: json?['startTime'] ?? '',
        endTime: json?['endTime'] ?? '',
        summary: json?['summary'] ?? '',
        isSubmitted: json?['isSubmitted'] ?? false,
        notes: ((json['notes'] ?? const []) as List<dynamic>)
            .map((e) => HandoverNote.from(e))
            .toList(),
      );
    } catch (e, s) {
      throw JsonParsingException(e, s);
    }
  }

  @override
  List<Object?> get props => [id, caregiverId, startTime, endTime, notes, summary, isSubmitted];
}
