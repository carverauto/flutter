import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/platform_views/airplay_view.dart';
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
          IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return const Dialog(
                    child: GoogleCastSolution(),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.cast,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

final StateProvider<CastDevice?> connectedCastingDevice =
    StateProvider<CastDevice?>((StateProviderRef<CastDevice?> ref) {
  return null;
});
final StateProvider<CastSession?> connectedCastSessionProvider =
    StateProvider<CastSession?>((StateProviderRef<CastSession?> ref) {
  return null;
});
final StateProvider<String?> currentCastingSessionId =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  return null;
});

class GoogleCastSolution extends ConsumerStatefulWidget {
  const GoogleCastSolution({super.key});

  @override
  ConsumerState<GoogleCastSolution> createState() => _GoogleCastSolutionState();
}

class _GoogleCastSolutionState extends ConsumerState<GoogleCastSolution> {
  late CastSession session;
  bool isSessionStarted = false;
  Future<void> _connect(BuildContext context, CastDevice object) async {
    session = await CastSessionManager().startSession(object);
    ref
        .read(connectedCastSessionProvider.notifier)
        .update((CastSession? state) => session);
    isSessionStarted = true;
    setState(() {});

    session.sendMessage(CastSession.kNamespaceReceiver, <String, dynamic>{
      'type': 'LAUNCH',
      'appId': '277F8C02', // set the appId of your app here
    });

    session.stateStream.listen((CastSessionState state) {
      if (state == CastSessionState.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected To ${object.name} for casting ')),
        );
      }
    });

    session.messageStream.listen((Map<String, dynamic> message) {
      if (message['status']['applications'] != null) {
        final List items = message['status']['applications'] as List;
        if (items.isNotEmpty) {
          final String sessionId =
              message['status']['applications'][0]['sessionId'] as String;
          ref
              .read(currentCastingSessionId.notifier)
              .update((String? state) => sessionId);
          _sendMessage(session, sessionId);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message Recieved--> $message')),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Launching Message Sent')),
    );
  }

  void _sendMessage(CastSession session, String sessionId) {
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
        'sessionId': sessionId,
      },
    );
  }

  // send message to pause the video on casting device
  void _pauseVideo(CastSession session, String sessionId) {
    final String? url = ref.read(currentlyPlayingVideoUrlProvider);

    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'PAUSE',
        'sessionId': sessionId,
      },
    );
  }

  // send message to play the video on casting device
  void _playVideo(CastSession session, String sessionId) {
    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'PLAY',
        'mediaSessionId': sessionId,
      },
    );
  }

  // send message to seek to a specific duration in the video on casting device

  void _seekVideo(CastSession session, String sessionId, int duration) {
    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'SEEK',
        'currentTime': duration,
        'mediaSessionId': sessionId,
      },
    );
  }

  // send message to stop the video on casting device
  void _stopVideo(CastSession session) {
    session.sendMessage(
      CastSession.kNamespaceMedia,
      <String, dynamic>{
        'type': 'STOP',
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final CastSession? preCastingSession =
        ref.read(connectedCastSessionProvider);

    if (preCastingSession != null) {
      session = preCastingSession;
      isSessionStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
          elevation: 2,
          shadowColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(kPaddingMediumConstant),
            child: Column(
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
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cast_outlined),
                              SizedBox(width: kPaddingSmallConstant),
                              Flexible(
                                child: Text(
                                  'Looking for casting devices...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kPaddingMediumConstant),
                          const CircularAdaptiveProgressIndicatorWithBg(),
                        ],
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cast_outlined),
                          SizedBox(width: kPaddingSmallConstant),
                          Flexible(
                            child: Text(
                              'No Chromecast Devices Founded',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: snapshot.data!.map((CastDevice device) {
                        return ListTile(
                          title: Text(
                            device.name,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            ref.read(connectedCastingDevice.notifier).update(
                                  (CastDevice? state) => device,
                                );
                            _connect(context, device);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                // add buttons for play, pause, seek
                if (isSessionStarted)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final String? sessionId =
                              ref.read(currentCastingSessionId);
                          if (sessionId != null) {
                            _pauseVideo(session, sessionId);
                          }
                        },
                        child: const Text('Pause'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final String? sessionId =
                              ref.read(currentCastingSessionId);
                          if (sessionId != null) {
                            _playVideo(session, sessionId);
                          }
                        },
                        child: const Text('Play'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final String? sessionId =
                              ref.read(currentCastingSessionId);
                          if (sessionId != null) {
                            _seekVideo(session, sessionId, 10000);
                          }
                        },
                        child: const Text('Seek'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
