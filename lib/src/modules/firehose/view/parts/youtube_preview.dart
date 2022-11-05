import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../chase_view/view/providers/providers.dart';

class YoutubePreview extends ConsumerStatefulWidget {
  const YoutubePreview({
    Key? key,
    required this.videoId,
    required this.body,
  }) : super(key: key);

  final String videoId;
  final String body;

  @override
  ConsumerState<YoutubePreview> createState() => _YoutubePreviewState();
}

class _YoutubePreviewState extends ConsumerState<YoutubePreview> {
  late YoutubePlayerController _controller;
  late bool isMuted;

  YoutubePlayerController initializeVideoController({String? youtubeUrl}) {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: true,
      ),
    );
    setState(() {});

    return _controller;
  }

  Future<void> changeYoutubeVideo(String url) async {
    initializeVideoController(
      youtubeUrl: url,
    );
    ref.read(playVideoProvider.state).update((bool state) => false);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    ref.read(playVideoProvider.state).update((bool state) => true);
  }

  @override
  void initState() {
    super.initState();
    initializeVideoController();
    isMuted = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          // showVideoProgressIndicator: true,
        ),
        builder: (BuildContext context, Widget video) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(kPaddingMediumConstant),
                margin: const EdgeInsets.all(kPaddingMediumConstant),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: primaryShadowColor,
                            blurRadius: blurValue,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusStandard),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            RepaintBoundary(child: video),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: VolumeOnOffButton(
                                isMuted: isMuted,
                                onTap: () {
                                  if (isMuted) {
                                    _controller.unMute();
                                  } else {
                                    _controller.mute();
                                  }
                                  setState(() {
                                    isMuted = !isMuted;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: kItemsSpacingMediumConstant,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: kItemsSpacingSmallConstant,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            side: const BorderSide(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                        const SizedBox(
                          width: kItemsSpacingSmallConstant,
                        ),
                        Tooltip(
                          message: 'Watch on Youtube',
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              final String url =
                                  'https://www.youtube.com/watch?v=${widget.videoId}';
                              launchURL(context, url);
                            },
                            child: const Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VolumeOnOffButton extends StatelessWidget {
  const VolumeOnOffButton({
    Key? key,
    required this.onTap,
    required this.isMuted,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      // shape: const CircleBorder(),
      onTap: onTap,
      child: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up,
      ),
    );
  }
}
