import 'package:chaseapp/src/shared/enums/device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_token.freezed.dart';
part 'push_token.g.dart';

@freezed
abstract class PushToken implements _$PushToken {
  PushToken._();
  @JsonSerializable(explicitToJson: true)
  const factory PushToken({
    required String Token,
    required int CreatedAt,
    required Device Device,
    required TokenType TokenType,
  }) = _PushToken;

  factory PushToken.fromJson(Map<String, dynamic> json) =>
      _$PushTokenFromJson(json);
}
