import 'dart:convert';
import 'dart:developer';

import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
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
    // ProviderStateBuilder<String>(
    //   loadingBuilder: () => AnimatedContainer(
    //     duration: Duration(milliseconds: 300),
    //     color: Colors.red,
    //     alignment: Alignment.center,
    //     child: CircularAdaptiveProgressIndicatorWithBg(),
    //   ),
    //   builder: (html, ref, child) {
    //     // Replace with custom preview
    //     log(html.toString());
    //     final remvoedScript = html.replaceFirst(
    //         '''<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>''',
    //         "");
    //     return EmbeddedTweetWebView(
    //       tweetId: tweetId,
    //     );
    //   },
    //   watchThisProvider: fetchTweetEmbedData(
    //       EmbedTweetParam(tweetId: tweetId, showMedia: showMedia)),
    //   logger: Logger('TweetPreview'),
    // );
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
  late double previewHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    previewHeight = Sizescaleconfig.screenheight! * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: previewHeight <= Sizescaleconfig.screenheight! * 0.5
            ? previewHeight
            : Sizescaleconfig.screenheight! * 0.5,
        maxWidth: double.infinity,
      ),
      child: Stack(
        children: [
          WebView(
            backgroundColor: Colors.black,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) {
              if (request.url.contains("twitter.com")) {
                return NavigationDecision.navigate;
              } else {
                if (isLoaded) {
                  launchUrl(request.url);
                }
                return NavigationDecision.prevent;
              }
            },
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
                      previewHeight = double.parse(message.message);
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
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: isLoaded
                ? SizedBox.shrink()
                : Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: CircularAdaptiveProgressIndicatorWithBg(),
                  ),
          ),
          // AnimatedCrossFade(
          //   firstChild: Container(
          //     color: Colors.blue,
          //     alignment: Alignment.center,
          //     child: CircularAdaptiveProgressIndicatorWithBg(),
          //   ),
          //   secondChild: Container(
          //     color: Colors.red,
          //     alignment: Alignment.center,
          //   ),
          //   crossFadeState:
          //       isLoaded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          //   duration: Duration(milliseconds: 3000),
          // ),
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
          '$tweetId',
          document.getElementById('container'),
          {
            theme: 'dark'
          }
        ).then( function( el ) {
          const widget = document.getElementById('container');
       Twitter.postMessage(widget.clientHeight);
          // Twitter.postMessage("Ready");
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