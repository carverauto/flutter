import 'dart:async';

import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/platform_views/airplay_view.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../providers/providers.dart';

class StreamingOptionsList extends StatelessWidget {
  const StreamingOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBg(
      color: Colors.grey[100]!.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS ||
              Theme.of(context).platform == TargetPlatform.macOS)
            const SizedBox(
              height: 44,
              width: 44,
              child: AirplayView(),
            ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              final MediaPlayer currentlyPlayingMediaType =
                  ref.watch(currentlyPlayingMediaProvider);
              if (currentlyPlayingMediaType == MediaPlayer.youtube ||
                  currentlyPlayingMediaType == MediaPlayer.m3u8) {
                return const SizedBox.shrink();
              }

              final CastSessionState castState =
                  ref.watch(googleCastVideoPlayControllerProvider);

              return IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: GoogleCastSolution(),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.cast,
                  color: castState == CastSessionState.connected
                      ? Colors.green
                      : castState == CastSessionState.connecting
                          ? Colors.yellow
                          : Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

final StateNotifierProvider<GoogleCastVideoPlayerController, CastSessionState>
    googleCastVideoPlayControllerProvider =
    StateNotifierProvider<GoogleCastVideoPlayerController, CastSessionState>(
  (
    StateNotifierProviderRef<GoogleCastVideoPlayerController, CastSessionState>
        ref,
  ) {
    return GoogleCastVideoPlayerController(ref: ref)..init();
  },
);

class GoogleCastVideoPlayerController extends StateNotifier<CastSessionState> {
  GoogleCastVideoPlayerController({required this.ref})
      : isSessionStarted = false,
        mediaSessionId = 0,
        super(CastSessionState.closed);

  final Ref ref;

  late CastSession session;
  CastDevice? castDevice;
  bool isSessionStarted;
  int mediaSessionId;
  late String sessionId;
  Duration duration = Duration.zero;

  void init() {
    listenForUrlChangesToVideo();
  }

  void listenForUrlChangesToVideo() {
    ref.listen<String?>(
      currentlyPlayingVideoUrlProvider,
      (String? previous, String? next) {
        if (next != null) {
          if (!isSessionStarted) {
            return;
          }
          final MediaPlayer mediaType = ref.read(currentlyPlayingMediaProvider);

          switch (mediaType) {
            case MediaPlayer.youtube:
              stopVideo();
              break;
            case MediaPlayer.mp4:
              _startSession(session, sessionId);

              break;
            case MediaPlayer.m3u8:
              stopVideo();
              break;
            default:
          }
        }
      },
    );
  }

  Future<void> _connect(BuildContext context, CastDevice device) async {
    castDevice = device;

    session = await CastSessionManager().startSession(device);

    isSessionStarted = true;

    session.sendMessage(CastSession.kNamespaceReceiver, <String, dynamic>{
      'type': 'LAUNCH',
      'appId': '277F8C02', // set the appId of your app here
    });

    session.stateStream.listen(listenToCastSessionState);

    session.messageStream.listen((Map<String, dynamic> message) {
      String type = message['type'] as String;

      if (type == 'MEDIA_STATUS') {
        mediaSessionId = message['status'][0]['mediaSessionId'] as int;
      }
      if (type == 'RECEIVER_STATUS') {
        sessionId = message['status']['applications'][0]['sessionId'] as String;

        _startSession(session, sessionId);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message Recieved--> $message')),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Launching Message Sent')),
    );
  }

  void listenToCastSessionState(CastSessionState value) {
    state = value;
    if (value == CastSessionState.connected) {
      Timer(const Duration(seconds: 1), () {
        seekVideo(duration: duration.inSeconds);
      });
    }
  }

  void _startSession(CastSession session, String sessionId) {
    final String? url = ref.read(currentlyPlayingVideoUrlProvider);

    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'LOAD',
        'media': {
          'contentId': url,
          'contentType': 'video/mp4',
          'streamType': 'BUFFERED',
        },
      },
    );
  }

  // send message to pause the video on casting device
  void pauseVideo() {
    if (state == CastSessionState.closed) {
      return;
    }
    if (isSessionStarted && state == CastSessionState.connected) {
      session.sendMessage(
        CastSession.kNamespaceMedia,
        <String, dynamic>{
          'type': 'PAUSE',
          'mediaSessionId': mediaSessionId,
        },
      );
    }
  }

  // send message to play the video on casting device
  void playVideo() {
    if (state == CastSessionState.closed) {
      return;
    }
    if (isSessionStarted && state == CastSessionState.connected) {
      session.sendMessage(
        CastSession.kNamespaceMedia,
        <String, dynamic>{
          'type': 'PLAY',
          'mediaSessionId': mediaSessionId,
        },
      );
    }
  }

  // send message to seek to a specific duration in the video on casting device

  void seekVideo({
    required int duration,
  }) {
    if (state == CastSessionState.closed) {
      return;
    }
    if (isSessionStarted && state == CastSessionState.connected) {
      session.sendMessage(
        CastSession.kNamespaceMedia,
        <String, dynamic>{
          'type': 'SEEK',
          'currentTime': duration,
          'mediaSessionId': mediaSessionId,
        },
      );
    }
  }

  // send message to stop the video on casting device
  void stopVideo() {
    if (state == CastSessionState.closed) {
      return;
    }

    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'STOP',
        'mediaSessionId': mediaSessionId,
      },
    );
    castDevice = null;
    isSessionStarted = false;
    state = CastSessionState.closed;
  }
}

class GoogleCastSolution extends ConsumerStatefulWidget {
  const GoogleCastSolution({super.key});

  @override
  ConsumerState<GoogleCastSolution> createState() => _GoogleCastSolutionState();
}

class _GoogleCastSolutionState extends ConsumerState<GoogleCastSolution> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPaddingMediumConstant),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<CastDevice>>(
            future: CastDiscoveryService().search(),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<CastDevice>> snapshot,
            ) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error.toString()}',
                  ),
                );
              } else if (!snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CastingDialoTitle(
                      title: 'Looking for casting devices...',
                    ),
                    SizedBox(height: kPaddingMediumConstant),
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularAdaptiveProgressIndicatorWithBg(),
                    ),
                  ],
                );
              }

              if (snapshot.data!.isEmpty) {
                return const CastingDialoTitle(
                  title: 'No casting devices found',
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CastingDialoTitle(
                    title: 'Available casting devices',
                  ),
                  const SizedBox(
                    height: kPaddingSmallConstant,
                  ),
                  ...snapshot.data!.map(
                    (CastDevice device) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(
                                  googleCastVideoPlayControllerProvider
                                      .notifier,
                                )
                                ._connect(
                                  context,
                                  device,
                                );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: kPaddingSmallConstant,
                              horizontal: kPaddingSmallConstant,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  device.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: kPaddingMediumConstant,
                                ),
                                Builder(
                                  builder: (BuildContext context) {
                                    final GoogleCastVideoPlayerController
                                        controller = ref.read(
                                      googleCastVideoPlayControllerProvider
                                          .notifier,
                                    );
                                    final CastSessionState castSessionState =
                                        ref.watch(
                                      googleCastVideoPlayControllerProvider,
                                    );

                                    if (!controller.isSessionStarted ||
                                        castSessionState ==
                                            CastSessionState.closed) {
                                      return const SizedBox.shrink();
                                    }

                                    final bool isActiveCastingDevice =
                                        controller.castDevice?.serviceName ==
                                            device.serviceName;

                                    if (!isActiveCastingDevice) {
                                      return const SizedBox.shrink();
                                    }

                                    return castSessionState ==
                                            CastSessionState.connected
                                        ? OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                            onPressed: controller.stopVideo,
                                            child: const Text(
                                              'Disconnect',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const CircularAdaptiveProgressIndicatorWithBg();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          // add buttons for play, pause, seek
        ],
      ),
    );
  }
}

class CastingDialoTitle extends StatelessWidget {
  const CastingDialoTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cast_outlined),
        const SizedBox(width: kPaddingSmallConstant),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
