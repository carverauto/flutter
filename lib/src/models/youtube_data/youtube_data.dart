import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_data.freezed.dart';
part 'youtube_data.g.dart';

@freezed
abstract class YoutubeData implements _$YoutubeData {
  @JsonSerializable(explicitToJson: true)
  const factory YoutubeData({
    required String videoId,
    required String text,
    required String channelId,
    required String userName,
    required String name,
    required String profileImageUrl,
    required int subcribersCount,
  }) = _YoutubeData;
  const YoutubeData._();
  factory YoutubeData.fromJson(Map<String, dynamic> json) =>
      _$YoutubeDataFromJson(json);
}
