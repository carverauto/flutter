import 'package:chaseapp/src/shared/util/convertors/datetimeconvertor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
abstract class NotificationData implements _$NotificationData {
  const NotificationData._();
  @JsonSerializable(explicitToJson: true)
  const factory NotificationData({
    required String interest,
    String? id,
    String? title,
    String? body,
    String? image,
    @DatetimeTimestampNullableConverter() DateTime? createdAt,
    Map<String, dynamic>? data,
  }) = _NotificationData;
  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
