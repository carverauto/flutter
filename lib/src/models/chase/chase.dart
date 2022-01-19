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
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id
    String? id,
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Live') required bool live,
    @JsonKey(name: 'CreatedAt')
    @DatetimeTimestampConverter()
        required DateTime createdAt,
    @JsonKey(name: 'Desc') required String desc,
    @JsonKey(name: 'ImageURL') String? imageURL,
    @JsonKey(name: 'Votes') required int votes,
    @JsonKey(name: 'Networks') List<Map<String, dynamic>>? networks,
    @JsonKey(name: 'Sentiment') Map? sentiment,
    @JsonKey(name: 'Wheels') Map? wheels,
  }) = _Chase;

  factory Chase.fromJson(Map<String, dynamic> json) => _$ChaseFromJson(json);
}
