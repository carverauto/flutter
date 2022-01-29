import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class UserData implements _$UserData {
  const UserData._();
  @JsonSerializable(explicitToJson: true)
  const factory UserData({
    required String uid,
    required String userName,
    required String email,
    required String photoURL,
    required int lastUpdated,
  }) = _UserData;
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
