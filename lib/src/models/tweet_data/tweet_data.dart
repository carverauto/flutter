import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_data.freezed.dart';
part 'tweet_data.g.dart';

@freezed
abstract class TweetData implements _$TweetData {
  @JsonSerializable(explicitToJson: true)
  const factory TweetData({
    required String tweetId,
    required String text,
    required String userId,
    required String userName,
    required String name,
    required String profileImageUrl,
  }) = _TweetData;
  const TweetData._();
  factory TweetData.fromJson(Map<String, dynamic> json) =>
      _$TweetDataFromJson(json);
}
