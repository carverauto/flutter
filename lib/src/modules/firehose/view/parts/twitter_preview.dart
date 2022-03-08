import 'dart:convert';

import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetPreview extends StatelessWidget {
  final String tweetId;
  final bool showMedia;
  TweetPreview({required this.tweetId, this.showMedia = true});

  @override
  Widget build(BuildContext context) {
    return ProviderStateBuilder<Map<String, dynamic>>(
      builder: (data, ref) {
        // Replace with custom preview
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            maxWidth: double.infinity,
          ),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: Uri.dataFromString(
              getHtmlBody(data["html"] as String),
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString(),
          ),
        );
      },
      watchThisProvider: fetchTweetEmbedData(
          EmbedTweetParam(tweetId: tweetId, showMedia: showMedia)),
      logger: Logger('TweetPreview'),
    );
  }
}

String getHtmlBody(String embedData) {
  return """
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
           
            *{box-sizing: border-box;margin:0px; padding:0px;}
              #widget {
                        display: flex;
                        justify-content: center;
                        margin: 0 auto;
                        max-width:100%;
                    }      
          </style>
        </head>
        <body>
            $embedData
        </body>
      </html>
    """;
}
