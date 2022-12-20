// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/util/convertors/datetimeconvertor.dart';

part 'changelog.freezed.dart';
part 'changelog.g.dart';

@freezed
abstract class Changelog implements _$Changelog {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Changelog({
    // TODO: Marking as optional for the moment but shoudln't be
    // All documents must have an id

    @JsonKey(name: 'Version') required String version,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'Description') required String description,
    @JsonKey(name: 'Updates') required List<String> updates,
    @DatetimeTimestampConverter() required DateTime updatedOn,
    @JsonKey(name: 'ImageUrl') String? imageUrl,
  }) = _Changelog;
  const Changelog._();

  factory Changelog.fromJson(Map<String, dynamic> json) =>
      _$ChangelogFromJson(json);
}
