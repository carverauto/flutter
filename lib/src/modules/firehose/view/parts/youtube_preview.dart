import 'dart:core';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePreview extends ConsumerStatefulWidget {
  const YoutubePreview({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final ChaseAppNotification notification;

  @override
  ConsumerState<YoutubePreview> createState() => _YoutubePreviewState();
}

class _YoutubePreviewState extends ConsumerState<YoutubePreview> {
  late YoutubePlayerController _controller;
  late bool isMuted;

  YoutubePlayerController initializeVideoController({String? youtubeUrl}) {
    _controller = YoutubePlayerController(
      initialVideoId: widget.notification.data!.youtubeId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    setState(() {});

    return _controller;
  }

  void changeYoutubeVideo(String url) async {
    initializeVideoController(
      youtubeUrl: url,
    );
    ref.read(playVideoProvider.state).update((state) => false);
    await Future<void>.delayed(Duration(milliseconds: 300));
    ref.read(playVideoProvider.state).update((state) => true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideoController();
    isMuted = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          // showVideoProgressIndicator: true,
        ),
        builder: (context, video) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Container(
                padding: EdgeInsets.all(kPaddingMediumConstant),
                margin: EdgeInsets.all(kPaddingMediumConstant),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(kBorderRadiusStandard),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: primaryShadowColor,
                          blurRadius: blurValue,
                          offset: Offset(0, 4),
                        )
                      ]),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusStandard),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            video,
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
                        widget.notification.body ?? "NA",
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
                            side: BorderSide(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Close"),
                        ),
                        SizedBox(
                          width: kItemsSpacingSmallConstant,
                        ),
                        Tooltip(
                          message: "Watch on Youtube",
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              final url =
                                  "https://www.youtube.com/watch?v=${widget.notification.data!.youtubeId!}";
                              launchURL(context, url);
                            },
                            child: Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                      ],
                    )
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
      shape: CircleBorder(),
      onTap: onTap,
      child: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up,
      ),
    );
  }
}
