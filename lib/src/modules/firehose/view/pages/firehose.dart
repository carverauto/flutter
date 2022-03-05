import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/twitter_preview.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/youtube_preview.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FireHoseView extends ConsumerWidget {
  FireHoseView({Key? key}) : super(key: key);

  final Logger _logger = Logger('FireHoseView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
      scrollController: ScrollController(),
      axis: Axis.vertical,
      builder: (notifications, ref) {
        return SliverToBoxAdapter(
          child: Container(
            height: 300,
            margin: EdgeInsets.all(kPaddingMediumConstant),
            color: Colors.white,
            child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      // create a new custom route for
                      showDialog<void>(
                          context: context,
                          builder: (context) {
                            if (notifications[index].title == 'streams') {
                              return YoutubePreview(
                                videoId: "TGx0rApSk6w",
                              );
                            } else if (notifications[index].title ==
                                'twitter') {
                              return Dialog(
                                // backgroundColor: Colors.transparent,
                                // elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      kPaddingMediumConstant),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (notifications[index].title == 'twitter')
                                      WebViewExample(
                                        tweetId:
                                            notifications[index].data!.tweetId!,
                                      ),
                                    if (notifications[index].title == 'streams')
                                      YoutubePreview(
                                        videoId: notifications[index]
                                            .data!
                                            .youtubeId!,
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          });
                    },
                    title: Text(notifications[index].title ?? "NA"),
                    subtitle: Text(notifications[index].body ?? "NA"),
                  );
                }),
          ),
        );
      },
      watchThisStateNotifierProvider:
          firehoseNotificationsStreamProvider(_logger),
      logger: _logger,
    );
  }
}
