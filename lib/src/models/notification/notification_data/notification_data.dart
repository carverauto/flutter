import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
abstract class NotificationData implements _$NotificationData {
  const NotificationData._();
  @JsonSerializable(explicitToJson: true)
  const factory NotificationData({
    @JsonKey(name: 'Id') String? id,
    @JsonKey(name: 'Image') String? image,
    @JsonKey(name: 'Tweetid') String? tweetId,
    @JsonKey(name: 'YoutubeId') String? youtubeId,
    @JsonKey(name: 'ConfigState') String? configState,
  }) = _NotificationData;
  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
