// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/enums/animtype.dart';
import '../../shared/util/convertors/alignment_convertor.dart';
import '../../shared/util/convertors/animtype_json_convertor.dart';
import '../../shared/util/convertors/datetimeconvertor.dart';
import '../../shared/util/convertors/label_convertor.dart';

part 'chase_animation_event.freezed.dart';
part 'chase_animation_event.g.dart';

@freezed
abstract class ChaseAnimationEvent implements _$ChaseAnimationEvent {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ChaseAnimationEvent({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @AnimTypeConvertor() required AnimType animtype,
    required String endpoint,
    required String animstate,
    @EventLabelTimestampConverter() required int label,
    required String videoId,
    required String artboard,
    required List<String> animations,
    @AlignmentConvertor() required Alignment alignment,
    // // required String alignment,
    @DatetimeTimestampConverter() required DateTime createdAt,
  }) = _ChaseAnimationEvent;
  const ChaseAnimationEvent._();

  factory ChaseAnimationEvent.fromJson(Map<String, dynamic> json) =>
      _$ChaseAnimationEventFromJson(json);
}
