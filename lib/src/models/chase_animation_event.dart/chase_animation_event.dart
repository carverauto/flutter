// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/alignment_convertor.dart';
import '../../shared/util/convertors/datetimeconvertor.dart';

part 'chase_animation_event.freezed.dart';
part 'chase_animation_event.g.dart';

@freezed
abstract class ChaseAnimationEvent implements _$ChaseAnimationEvent {
  const ChaseAnimationEvent._();
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ChaseAnimationEvent({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    required String animtype,
    required String endpoint,
    required String animstate,
    required int label,
    required String videoId,
    required String artboard,
    required String animation,
    @AlignmentConvertor() required Alignment alignment,
    // required String alignment,
    @DatetimeTimestampConverter() required DateTime createdAt,
  }) = _ChaseAnimationEvent;
}
