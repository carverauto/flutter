// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chase_stream.freezed.dart';
part 'chase_stream.g.dart';

@freezed
abstract class ChaseStream implements _$ChaseStream {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ChaseStream({
    @JsonKey(name: 'Tier') required int tier,
    @JsonKey(name: 'URL') required String url,
  }) = _ChaseStream;
  const ChaseStream._();

  factory ChaseStream.fromJson(Map<String, dynamic> json) =>
      _$ChaseStreamFromJson(json);
}
