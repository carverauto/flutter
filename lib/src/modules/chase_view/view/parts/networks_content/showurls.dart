import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../../const/colors.dart';
import '../../../../../const/images.dart';
import '../../../../../const/sizings.dart';
import '../../../../../models/chase/network/chase_network.dart';
import '../../../../../models/chase/network/chase_stream/chase_stream.dart';
import '../../../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../../../shared/widgets/buttons/glass_button.dart';
import '../../providers/providers.dart';
import '../mp4_player/providers.dart';
import 'watch_here_links.dart';

class URLView extends ConsumerWidget {
  const URLView({
    super.key,
    required this.networkContentMap,
    required this.isStreams,
    required this.logger,
  });
  final List<NetworkContentMapped> networkContentMap;
  final bool isStreams;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            networkContentMap.map<Widget>((NetworkContentMapped networkMap) {
          return _NetworkLinks(
            networkContentMap: networkMap,
            isStreams: isStreams,
            logger: logger,
          );
        }).toList(),
      ),
    );
  }
}

class _NetworkLinks extends ConsumerWidget {
  const _NetworkLinks({
    required this.networkContentMap,
    required this.isStreams,
    required this.logger,
  });

  final NetworkContentMapped networkContentMap;
  final bool isStreams;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? currentlyPlayingUrl =
        ref.watch(currentlyPlayingVideoUrlProvider);

    final ChaseNetwork network = networkContentMap.network;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kItemsSpacingExtraSmallConstant,
      ),
      child: GlassButton(
        padding: const EdgeInsets.all(kPaddingSmallConstant),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              toBeginningOfSentenceCase(network.name) ?? 'NA',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              ),
            ),
            if (isStreams)
              for (final ChaseStream stream in networkContentMap.youtubeStreams)
                Padding(
                  padding: const EdgeInsets.only(
                    left: kPaddingSmallConstant,
                  ),
                  child: StreamButton(
                    currentlyPlayingUrl: currentlyPlayingUrl,
                    stream: stream,
                    isYoutube: true,
                  ),
                ),
            if (isStreams)
              for (final ChaseStream stream in networkContentMap.mp4Streams)
                Padding(
                  padding: const EdgeInsets.only(
                    left: kPaddingSmallConstant,
                  ),
                  child: StreamButton(
                    currentlyPlayingUrl: currentlyPlayingUrl,
                    stream: stream,
                    isYoutube: false,
                  ),
                ),
            if (!isStreams)
              for (final ChaseStream stream in networkContentMap.others)
                Builder(
                  builder: (BuildContext context) {
                    final String? networkUrl = getNetworkLogUrl(stream.url);
                    final bool isInvalidUrl =
                        networkUrl == null || networkUrl.isEmpty;

                    if (isInvalidUrl) {
                      logger.warning(
                        'Invalid ${networkContentMap.network.name} NetworkUrl : $networkUrl',
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: kPaddingSmallConstant,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await launchURL(context, stream.url);
                        },
                        child: CircleAvatar(
                          backgroundColor: primaryColor.shade300,
                          backgroundImage:
                              !isInvalidUrl ? NetworkImage(networkUrl) : null,
                          child: !isInvalidUrl
                              ? null
                              : Icon(
                                  Icons.question_mark_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class StreamButton extends ConsumerWidget {
  const StreamButton({
    super.key,
    required this.currentlyPlayingUrl,
    required this.stream,
    required this.isYoutube,
  });

  final String? currentlyPlayingUrl;
  final ChaseStream stream;
  final bool isYoutube;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeStateProvider<bool?> playPauseStateProvider = isYoutube
        ? youtubePlauerPlayPauseEventsStreamProovider
        : mp4PlauerPlayPauseStateProovider;
    ref.listen<bool>(isPlayingAnyVideoProvider, (bool? previous, bool next) {
      ref.read(playPauseStateProvider.state).update((bool? state) => next);
    });

    final bool? playerPlayPauseState = ref.watch(
      playPauseStateProvider,
    );
    final bool isActive = currentlyPlayingUrl == stream.url;
    final bool currentValue = playerPlayPauseState ?? isActive;

    return GestureDetector(
      onTap: () {
        ref.read(playPauseStateProvider.notifier).update(
              (bool? state) => isActive ? !currentValue : true,
            );
        if (isYoutube) {
          ref.refresh(youtubePlauerPlayEventsStreamProovider);
          ref
              .read(youtubePlauerPlayEventsStreamProovider.state)
              .update((String? state) => stream.url);
        } else {
          ref.refresh(mp4PlauerPlayEventsStreamProovider);
          ref
              .read(mp4PlauerPlayEventsStreamProovider.state)
              .update((String? state) => stream.url);
        }

        ref
            .read(currentlyPlayingVideoUrlProvider.state)
            .update((String? state) => stream.url);
      },
      child: isActive
          ? CircleAvatar(
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  const AnimatingGradientShaderBuilder(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Icon(
                    isActive && currentValue
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          : CircleAvatar(
              backgroundColor: isYoutube ? Colors.red : Colors.blue,
              child: FittedBox(
                child: Icon(
                  isActive && currentValue
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

String? getNetworkLogUrl(String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }
  // parse the url to get the hose from it. match it agains the keys in the networkUrls
  final String hostName = Uri.parse(url).host.replaceAll('www.', '');
  final String? network = networkUrls.entries
      .firstWhereOrNull(
        (MapEntry<String, String> entry) => entry.key.contains(hostName),
      )
      ?.value;

  return network != null ? 'https://chaseapp.tv/$network' : defaultPhotoURL;
}

Map<String, String> networkUrls = {
  'foxla.com': '/networks/foxla.jpg',
  'losangeles.cbslocal.com': '/networks/cbsla.jpg',
  'nbclosangeles.com': '/networks/nbclosangeles.jpg',
  'abc7.com': '/networks/abc7.jpg',
  'ktla.com': '/networks/ktla.jpg',
  'broadcastify.com': '/networks/broadcastify.jpg',
  'audio12.broadcastify.com': '/networks/broadcastify.jpg',
  'facebook.com': '/networks/facebook.jpg',
  'm.facebook.com': '/networks/facebook.jpg',
  'wsvn.com': '/networks/wsvn.jpg',
  'twitter.com': '/Twitter_logo_blue_32.png',
  'nbcmiami.com': '/networks/nbc6.jpg',
  'iheart.com': '/networks/iheart.jpg',
  'kdoc.tv': '/networks/kdoc.jpg',
  'youtube.com': '/networks/youtube.jpg',
  'youtu.be': '/networks/youtube.jpg',
  'pscp.tv': '/networks/periscope.png',
  'fox10phoenix.com': '/networks/fox10.png',
  'kfor.com': '/networks/kfor.jpg',
  'kctv5.com': '/networks/kctv5.jpg',
  'fox4news.com': '/networks/fox4.jpg',
  'nbcdfw.com': '/networks/nbcdfw.jpg',
  'khou.com': '/networks/khou.jpg',
  'wesh.com': '/networks/wesh.jpg',
  'cbs8.com': '/networks/cbs8.png',
  'abc13.com': '/networks/abc13.png',
  'wsoctv.com': '/networks/wsoc.png',
  'news9.com': '/networks/news9.jpg',
};
