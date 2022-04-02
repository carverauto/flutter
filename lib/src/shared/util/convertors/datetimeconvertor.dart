import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class DatetimeTimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const DatetimeTimestampConverter();

  @override
  DateTime fromJson(dynamic date) {
    return parseDate(date);
  }

  @override
  Timestamp toJson(
    DateTime date,
  ) {
    final DateTime utcDate = date.toUtc();
    log("message: 'utcDate: $utcDate");

    return Timestamp.fromDate(utcDate);
  }
}

class DatetimeTimestampNullableConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const DatetimeTimestampNullableConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  @override
  Timestamp? toJson(DateTime? date, {bool? stringDate}) {
    return date == null ? null : Timestamp.fromDate(date);
  }
}

DateTime parseDate(dynamic date) {
  if (date == null) {
    return DateTime.now();
  } else if (date is String) {
    final DateTime? parsedDate = DateTime.tryParse(date);

    return parsedDate ?? DateTime.now();
  } else if (date is int) {
    return DateTime.fromMillisecondsSinceEpoch(date);
  } else if (date is Timestamp) {
    return date.toDate();
  } else {
    return date as DateTime;
  }
}
