// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/datetimeconvertor.dart';
import 'network/chase_network.dart';

part 'chase.freezed.dart';
part 'chase.g.dart';

@freezed
abstract class Chase implements _$Chase {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Chase({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    required String id,
    @JsonKey(name: 'Name') required String? name,
    @JsonKey(name: 'Live') required bool? live,
    @JsonKey(name: 'CreatedAt')
    @DatetimeTimestampNullableConverter()
        required DateTime? createdAt,
    @JsonKey(name: 'Desc') required String? desc,
    @JsonKey(name: 'ImageURL') String? imageURL,
    @JsonKey(name: 'Votes') required int? votes,
    @JsonKey(name: 'Networks') List<ChaseNetwork>? networks,
    @JsonKey(name: 'sentiment') Map? sentiment,
    @JsonKey(name: 'Wheels') Map<String, dynamic>? wheels,
  }) = _Chase;
  const Chase._();

  factory Chase.fromJson(Map<String, dynamic> json) => _$ChaseFromJson(json);
}
