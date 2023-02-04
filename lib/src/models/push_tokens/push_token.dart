import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/enums/device.dart';
import '../../shared/enums/token_type.dart';

part 'push_token.freezed.dart';
part 'push_token.g.dart';

@freezed
abstract class PushToken implements _$PushToken {
  @JsonSerializable(explicitToJson: true)
  const factory PushToken({
    required String token,
    required int created_at,
    required DeviceOS device,
    required TokenType type,
  }) = _PushToken;
  const PushToken._();

  factory PushToken.fromJson(Map<String, dynamic> json) =>
      _$PushTokenFromJson(json);
}
