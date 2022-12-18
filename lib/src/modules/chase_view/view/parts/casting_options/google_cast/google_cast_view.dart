import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../const/sizings.dart';
import '../../../../../../shared/widgets/loaders/loading.dart';
import 'google_cast_controller.dart';

class GoogleCastButton extends ConsumerStatefulWidget {
  const GoogleCastButton({super.key});

  @override
  ConsumerState<GoogleCastButton> createState() => _GoogleCastButtonState();
}

class _GoogleCastButtonState extends ConsumerState<GoogleCastButton> {
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
                                .connect(
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
                                Expanded(
                                  child: Text(
                                    device.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
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
