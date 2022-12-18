import 'dart:async';

import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../providers/providers.dart';

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
  Logger logger = Logger('GoogleCastVideoPlayerController');

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

  Future<void> connect(BuildContext context, CastDevice device) async {
    castDevice = device;

    session = await CastSessionManager().startSession(device);

    isSessionStarted = true;

    session.sendMessage(CastSession.kNamespaceReceiver, <String, dynamic>{
      'type': 'LAUNCH',
      'appId': '277F8C02', // set the appId of your app here
    });

    session.stateStream.listen((CastSessionState value) {
      listenToCastSessionState(value);
      if (value == CastSessionState.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connected to device')),
        );
      }
    });

    session.messageStream.listen((Map<String, dynamic> message) {
      String type = message['type'] as String;

      if (type == 'MEDIA_STATUS') {
        mediaSessionId = message['status'][0]['mediaSessionId'] as int;
      }
      if (type == 'RECEIVER_STATUS') {
        sessionId = message['status']['applications'][0]['sessionId'] as String;

        _startSession(session, sessionId);
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Message Recieved--> $message')),
      // );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connecting to device...')),
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
