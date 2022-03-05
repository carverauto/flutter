import 'package:chaseapp/src/models/notification/notification_data/notification_data.dart';
import 'package:chaseapp/src/shared/util/convertors/datetimeconvertor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class ChaseAppNotification implements _$ChaseAppNotification {
  const ChaseAppNotification._();
  @JsonSerializable(explicitToJson: true)
  const factory ChaseAppNotification({
    @JsonKey(name: 'Interest') required String interest,
    String? id,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Body') String? body,
    @JsonKey(name: 'Image') String? image,
    @JsonKey(name: 'CreatedAt')
    @DatetimeTimestampNullableConverter()
        DateTime? createdAt,
    @JsonKey(name: 'Data') NotificationData? data,
  }) = _ChaseAppNotification;
  factory ChaseAppNotification.fromJson(Map<String, dynamic> json) =>
      _$ChaseAppNotificationFromJson(json);
}
