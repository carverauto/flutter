import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:social_embed_webview/platforms/twitter.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String tweetId;
  WebViewExample({required this.tweetId});
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderStateBuilder<Map<String, dynamic>>(
      builder: (data, ref) {
        return SocialEmbed(
          socialMediaObj: TwitterEmbedData(embedHtml: data["html"] as String),
        );
      },
      watchThisProvider: fetchTweetEmbedData(widget.tweetId),
      logger: Logger('WebViewExample'),
    );
  }
}
