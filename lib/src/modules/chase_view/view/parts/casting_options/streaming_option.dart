import 'package:cast/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/top_level_providers/services_providers.dart';
import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../in_app_purchases/views/view_helpers.dart';
import '../../providers/providers.dart';
import 'aiplay/airplay_view.dart';
import 'google_cast/google_cast_controller.dart';
import 'google_cast/google_cast_view.dart';

class StreamingOptionsList extends ConsumerWidget {
  const StreamingOptionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // check if premium
    final bool isPremium =
        ref.watch(inAppPurchasesStateNotifier.notifier).isPremiumMember;

    return GlassBg(
      color: Colors.grey[100]!.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS ||
              Theme.of(context).platform == TargetPlatform.macOS)
            SizedBox(
              height: 44,
              width: 44,
              child: !isPremium
                  ? GestureDetector(
                      onTap: () async {
                        await showInAppPurchasesBottomSheet(context);
                      },
                      child: const Icon(
                        Icons.airplay_rounded,
                        color: Colors.grey,
                      ),
                    )
                  : const AirplayButton(),
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
                onPressed: () async {
                  if (!isPremium) {
                    await showInAppPurchasesBottomSheet(context);

                    return;
                  }

                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: GoogleCastButton(),
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
                          : !isPremium
                              ? Colors.grey
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
