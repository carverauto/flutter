import 'package:cast/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/util/helpers/is_valid_youtube_url.dart';
import '../../../../../shared/widgets/buttons/glass_button.dart';
import '../../providers/providers.dart';
import 'aiplay/airplay_view.dart';
import 'google_cast/google_cast_controller.dart';
import 'google_cast/google_cast_view.dart';

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
              child: AirplayButton(),
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
