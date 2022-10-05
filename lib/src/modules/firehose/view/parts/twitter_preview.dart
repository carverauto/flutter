import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../shared/util/helpers/launchLink.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../../../../shared/widgets/loaders/loading.dart';

class TweetPreview extends StatelessWidget {
  const TweetPreview({required this.tweetId, this.showMedia = true});
  final String tweetId;
  final bool showMedia;

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
  late WebViewController webViewController;
  late final String initialUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialUrl = Uri.dataFromString(
      getHtmlBody(widget.tweetId),
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
    previewHeight = Sizescaleconfig.screenheight! * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: previewHeight <= Sizescaleconfig.screenheight! * 0.5
            ? previewHeight
            : Sizescaleconfig.screenheight! * 0.5,
      ),
      child: Stack(
        children: [
          WebView(
            backgroundColor: Colors.transparent,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              log('message');
              if (request.url == initialUrl) {
                return NavigationDecision.navigate;
              } else if (request.url.contains('twitter.com')) {
                if (isLoaded) {
                  launchUrl(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              } else {
                if (isLoaded) {
                  launchUrl(request.url);
                }
                return NavigationDecision.prevent;
              }
            },
            onPageFinished: (String value) {
              log('OnPageFinished');
            },
            onWebResourceError: (WebResourceError e) {
              log('error', error: e.description);
            },
            javascriptChannels: <JavascriptChannel>{}..add(
                JavascriptChannel(
                  name: 'Twitter',
                  onMessageReceived: (JavascriptMessage message) {
                    log(message.message);
                    setState(() {
                      isLoaded = true;
                      previewHeight = double.parse(message.message);
                    });
                  },
                ),
              ),
            onWebViewCreated: (WebViewController controller) {
              log('onWebViewCreated');
              webViewController = controller;
              setState(() {});
            },
            initialUrl: initialUrl,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: isLoaded
                ? const SizedBox.shrink()
                : Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const CircularAdaptiveProgressIndicatorWithBg(),
                  ),
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
              #container {
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