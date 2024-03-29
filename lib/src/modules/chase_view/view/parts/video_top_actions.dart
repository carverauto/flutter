import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/sizings.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../providers/providers.dart';
import 'animations_overlay_toggle_switch.dart';
import 'casting_options/streaming_option.dart';
import 'mp4_player/mp4_player.dart';

class VideoTopActions extends StatefulWidget {
  const VideoTopActions({
    super.key,
    required this.controller,
  });
  final YoutubePlayerController controller;

  @override
  State<VideoTopActions> createState() => _VideoTopActionsState();
}

class _VideoTopActionsState extends State<VideoTopActions> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kPaddingSmallConstant,
          right: kPaddingSmallConstant,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                popVideoView(context, widget.controller.toggleFullScreenMode);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const StreamingOptionsList(),
            const SizedBox(width: kPaddingSmallConstant),
            const AnimationsOverlayToggleSwitch(),
            SizedBox(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 68
                  : kItemsSpacingSmallConstant,
            ),
          ],
        ),
      ),
    );
  }
}

final AutoDisposeFutureProvider<bool?> localNetworkAccessStatusFutureProvider =
    FutureProvider.autoDispose<bool?>(
  (AutoDisposeFutureProviderRef<bool?> ref) async {
    final bool isShownPermissionDialog = ref
            .read(sharedPreferancesProvider)
            .getBool('isShownLANPermissionDialog') ??
        false;

    return isShownPermissionDialog
        ? await LocalNetworkAuthorization().requestAuthorization()
        : isShownPermissionDialog;
  },
);

class ChaseAppChromeCastButton extends ConsumerStatefulWidget {
  const ChaseAppChromeCastButton({
    super.key,
  });

  @override
  ConsumerState<ChaseAppChromeCastButton> createState() =>
      _ChaseAppChromeCastButtonState();
}

class _ChaseAppChromeCastButtonState
    extends ConsumerState<ChaseAppChromeCastButton>
    with WidgetsBindingObserver {
  late ChromeCastController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // add didChangeLifeCycle call

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.refresh(localNetworkAccessStatusFutureProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentlyPlayingUrl =
        ref.watch(currentlyPlayingVideoUrlProvider);
    final AsyncValue<bool?> state =
        ref.watch(localNetworkAccessStatusFutureProvider);
    String? finalUrl;
    if (currentlyPlayingUrl != null) {
      final bool isMp4 = ismp4orm3u8url(currentlyPlayingUrl);

      if (isMp4) {
        // parse and get part till .mp4 or m3u8
        finalUrl = currentlyPlayingUrl.split('?').first;
      } else {
        finalUrl = currentlyPlayingUrl;
      }

      log(finalUrl);
    }

    return state.when(
      data: (bool? data) {
        return data == true
            ? DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ChromeCastButton(
                      size: kIconSizeLargeConstant,
                      color: Colors.red,
                      onButtonCreated: (ChromeCastController controller) {
                        setState(() => _controller = controller);

                        _controller.addSessionListener();
                      },
                      onSessionStarted: () {
                        if (finalUrl != null) {
                          _controller.loadMedia(
                            finalUrl,
                          );
                        }
                      },
                    ),
                    const IgnorePointer(
                      child: Icon(
                        Icons.cast,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            : IconButton(
                onPressed: () async {
                  final bool? isAccepted = await showCupertinoDialog<bool?>(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            child: Icon(
                              Icons.cast,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: kItemsSpacingSmallConstant,
                          ),
                          const Flexible(
                            child: Text(
                              'Casting Permission',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: const Text(
                        'To use casting feature, we need to access your local network to connect to your casting device. Please allow the permission when asked at next step.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(kButtonPaddingMedium),
                          ),
                          onPressed: () async {
                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'Enable',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: kPaddingSmallConstant,
                        ),
                        TextButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(kButtonPaddingMedium),
                          ),
                          onPressed: () async {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            'Later',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (isAccepted == true) {
                    try {
                      await ref
                          .read(sharedPreferancesProvider)
                          .setBool('isShownLANPermissionDialog', true);

                      final bool? permission = await LocalNetworkAuthorization()
                          .requestAuthorization();

                      if (permission != null) {
                        if (permission) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Casting Enabled',
                              ),
                              action: SnackBarAction(
                                label: 'Open Settings',
                                onPressed: () async {
                                  await openAppSettings();
                                },
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Update permissions later in app settings.',
                              ),
                              action: SnackBarAction(
                                label: 'Open Settings',
                                onPressed: () async {
                                  await openAppSettings();
                                },
                              ),
                            ),
                          );
                        }
                      }
                      // final String? deviceIp = await NetworkInfo().getWifiIP();

                      // const Duration timeOutDuration =
                      //     Duration(milliseconds: 100);
                      // await Socket.connect(
                      //   deviceIp,
                      //   80,
                      //   timeout: timeOutDuration,
                      // );
                    } catch (e) {
                      // if (permissionStatus != null && !permissionStatus) {
                      //   await openAppSettings();
                      // }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Something went wrong. Try updating permission in app settings.',
                          ),
                          action: SnackBarAction(
                            label: 'Open Settings',
                            onPressed: () async {
                              await openAppSettings();
                            },
                          ),
                        ),
                      );
                    } finally {
                      ref.refresh(localNetworkAccessStatusFutureProvider);
                    }
                  }
                  ref.refresh(localNetworkAccessStatusFutureProvider);
                },
                icon: const Icon(
                  Icons.cast,
                  color: Colors.black,
                ),
              );
      },
      loading: () => const SizedBox.shrink(),
      error: (Object error, StackTrace? stack) => const SizedBox.shrink(),
    );
  }
}

class LocalNetworkAuthorization {
  static const MethodChannel _channel =
      MethodChannel('local_network_authorization');

  Future<bool?> requestAuthorization() async {
    // Request permission to access the local network.
    final bool? isPermissionGranted =
        await _channel.invokeMethod<bool?>('requestLocalNetworkAuthorization');

    // Return the result of the permission request.
    return isPermissionGranted;
  }
}
