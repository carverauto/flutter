// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/datetimeconvertor.dart';

part 'interest.freezed.dart';
part 'interest.g.dart';

@freezed
abstract class Interest implements _$Interest {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Interest({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    required String instanceId,
    required String name,
    required bool isCompulsory,
    required bool isDefault,
    required bool isPremium,
    @DatetimeTimestampConverter() required DateTime createdAt,
  }) = _Interest;
  const Interest._();

  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
}
