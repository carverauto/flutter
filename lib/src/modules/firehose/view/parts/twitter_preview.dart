import 'dart:convert';
import 'dart:developer';

import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TweetPreview extends StatelessWidget {
  final String tweetId;
  final bool showMedia;
  TweetPreview({required this.tweetId, this.showMedia = true});

  @override
  Widget build(BuildContext context) {
    return EmbeddedTweetWebView(
      tweetId: tweetId,
    );
    ProviderStateBuilder<String>(
      loadingBuilder: () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        color: Colors.red,
        alignment: Alignment.center,
        child: CircularAdaptiveProgressIndicatorWithBg(),
      ),
      builder: (html, ref, child) {
        // Replace with custom preview
        log(html.toString());
        final remvoedScript = html.replaceFirst(
            '''<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''',
            "");
        return EmbeddedTweetWebView(
          tweetId: tweetId,
        );
      },
      watchThisProvider: fetchTweetEmbedData(
          EmbedTweetParam(tweetId: tweetId, showMedia: showMedia)),
      logger: Logger('TweetPreview'),
    );
  }
}

class EmbeddedTweetWebView extends StatefulWidget {
  const EmbeddedTweetWebView({
    Key? key,
    required this.tweetId,
  }) : super(key: key);

  final String tweetId;

  @override
  State<EmbeddedTweetWebView> createState() => _EmbeddedTweetWebViewState();
}

class _EmbeddedTweetWebViewState extends State<EmbeddedTweetWebView> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        maxWidth: double.infinity,
        minHeight: 200,
      ),
      child: Stack(
        children: [
          WebView(
            backgroundColor: Colors.black,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (value) {
              log("OnPageFinished");
            },
            onWebResourceError: (e) {
              log("error", error: e.description);
            },
            javascriptChannels: Set()
              ..add(
                JavascriptChannel(
                  name: "Twitter",
                  onMessageReceived: (JavascriptMessage message) {
                    log(message.message);
                    setState(() {
                      isLoaded = true;
                    });
                  },
                ),
              ),
            onWebViewCreated: (controller) {
              log("onWebViewCreated");
            },
            initialUrl: Uri.dataFromString(
              getHtmlBody(widget.tweetId),
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString(),
          ),
          if (!isLoaded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: Colors.blue,
              alignment: Alignment.center,
              child: CircularAdaptiveProgressIndicatorWithBg(),
            ),
        ],
      ),
    );
  }
}

String getHtmlBody(String tweetId) {
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
                        max-height:100%;
                    }      
          </style>
        </head>
        <body>
            <div id="container"></div>
     
                
        </body>
        <script src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
        <script>
       

         var twtter = window.twttr;
         twttr.ready().then( function( el ) {
        });;
         twttr.widgets.createTweet(
          '1502154545123581954',
          document.getElementById('container'),
          {
            theme: 'dark'
          }
        ).then( function( el ) {
          
          Twitter.postMessage("Ready");
        });


        </script>
        
      </html>
    """;
}

 // window.addEventListener('load', function() {
        //             var widget = document.getElementById('container');
        //             widget.innerHTML = $embedData;
        //              Twitter.postMessage('Embeded');
        //         });