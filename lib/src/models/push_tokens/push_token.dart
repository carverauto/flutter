import 'package:chaseapp/src/shared/enums/device.dart';
import 'package:chaseapp/src/shared/enums/token_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_token.freezed.dart';
part 'push_token.g.dart';

@freezed
abstract class PushToken implements _$PushToken {
  const PushToken._();
  @JsonSerializable(explicitToJson: true)
  const factory PushToken({
    required String token,
    required int created_at,
    required DeviceOS device,
    required TokenType type,
  }) = _PushToken;

  factory PushToken.fromJson(Map<String, dynamic> json) =>
      _$PushTokenFromJson(json);
}
