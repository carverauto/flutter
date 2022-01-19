import 'package:chaseapp/src/shared/util/convertors/datetimeconvertor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chase.freezed.dart';
part 'chase.g.dart';

@freezed
abstract class Chase implements _$Chase {
  const Chase._();
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Chase({
    required String id,
    required String name,
    required bool live,
    @DatetimeTimestampConverter() required DateTime createdAt,
    required String desc,
    String? imageURL,
    required int votes,
    List? networks,
    Map? sentiment,
    Map? wheels,
  }) = _Chase;

  factory Chase.fromJson(Map<String, dynamic> json) => _$ChaseFromJson(json);
}
