import 'package:freezed_annotation/freezed_annotation.dart';

class EventLabelTimestampConverter implements JsonConverter<int, dynamic> {
  const EventLabelTimestampConverter();

  @override
  int fromJson(dynamic label) {
    if (label is int) {
      return label;
    } else if (label is String) {
      final int? finalLabel = int.tryParse(label);

      return finalLabel ?? 0;
    } else {
      return 0;
    }
  }

  @override
  int toJson(
    int label,
  ) {
    return label;
  }
}
