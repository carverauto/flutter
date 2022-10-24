import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/datetimeconvertor.dart';
import '../push_tokens/push_token.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class UserData implements _$UserData {
  @JsonSerializable(explicitToJson: true)
  const factory UserData({
    required String uid,
    String? userName,
    String? email,
    String? photoURL,
    required int lastUpdated,
    @DatetimeTimestampNullableConverter() DateTime? lastTokenUpdate,
    List<PushToken>? tokens,
  }) = _UserData;
  const UserData._();
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
