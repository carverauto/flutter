import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:social_embed_webview/platforms/twitter.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class TweetPreview extends StatelessWidget {
  final String tweetId;
  final bool showMedia;
  TweetPreview({required this.tweetId, this.showMedia = true});

  @override
  Widget build(BuildContext context) {
    return ProviderStateBuilder<Map<String, dynamic>>(
      builder: (data, ref) {
        // Replace with custom preview
        return SocialEmbed(
          socialMediaObj: TwitterEmbedData(embedHtml: data["html"] as String),
        );
      },
      watchThisProvider: fetchTweetEmbedData(
          EmbedTweetParam(tweetId: tweetId, showMedia: showMedia)),
      logger: Logger('TweetPreview'),
    );
  }
}
