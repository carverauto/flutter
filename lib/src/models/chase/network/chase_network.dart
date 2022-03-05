// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chase_network.freezed.dart';
part 'chase_network.g.dart';

@freezed
abstract class ChaseNetwork implements _$ChaseNetwork {
  const ChaseNetwork._();
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory ChaseNetwork({
    @JsonKey(name: 'Logo') required String? logo,
    @JsonKey(name: 'Name') required String? name,
    @JsonKey(name: 'Other') required String? other,
    @JsonKey(name: 'Tier') required int? tier,
    @JsonKey(name: 'URL') String? url,
  }) = _ChaseNetwork;

  factory ChaseNetwork.fromJson(Map<String, dynamic> json) =>
      _$ChaseNetworkFromJson(json);
}
