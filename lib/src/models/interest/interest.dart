// ignore_for_file: invalid_annotation_target

import 'package:chaseapp/src/shared/util/convertors/datetimeconvertor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest.freezed.dart';
part 'interest.g.dart';

@freezed
abstract class Interest implements _$Interest {
  const Interest._();
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Interest({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    required String instanceId,
    required String name,
    required bool isCompulsory,
    @DatetimeTimestampConverter() required DateTime createdAt,
  }) = _Interest;

  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
}
