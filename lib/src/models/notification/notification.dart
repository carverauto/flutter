import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/datetimeconvertor.dart';
import 'notification_data/notification_data.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class ChaseAppNotification implements _$ChaseAppNotification {
  const ChaseAppNotification._();
  @JsonSerializable(explicitToJson: true)
  const factory ChaseAppNotification({
    @JsonKey(name: 'Interest') required String interest,
    required String id,
    @JsonKey(name: 'Type') required String type,
    @JsonKey(name: 'Title') required String title,
    @JsonKey(name: 'Body') required String body,
    // @JsonKey(name: 'Image') String? image,
    @JsonKey(name: 'CreatedAt')
    @DatetimeTimestampConverter()
        required DateTime createdAt,
    @JsonKey(name: 'Data') NotificationData? data,
  }) = _ChaseAppNotification;
  factory ChaseAppNotification.fromJson(Map<String, dynamic> json) =>
      _$ChaseAppNotificationFromJson(json);
}
