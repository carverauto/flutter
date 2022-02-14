import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showChatsDialog(BuildContext context, Chase chase) {
  final channel = client.channel(
    'livestream',
    id: chase.id,
    extraData: {
      'name': chase.name ?? "NA",
    },
  );
  channel.watch();
  showModalBottomSheet<void>(
    context: context,
    // enableDrag: false,
    elevation: 1,
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        kBorderRadiusStandard,
      ),
    ),
    builder: (context) {
      return AnimatedPadding(
        duration: Duration(milliseconds: 300),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusStandard),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(kPaddingMediumConstant)
                      .copyWith(bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chats",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: StreamChannel(
                    channel: channel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: MessageListView(
                            loadingBuilder: (context) =>
                                CircularAdaptiveProgressIndicatorWithBg(),
                            errorBuilder: (context, e) {
                              return ChaseAppErrorWidget(onRefresh: () {
                                // ref.refresh(chatChannelProvider(chase));
                              });
                            },
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.manual,
                          ),
                        ),
                        MessageInput(
                          disableAttachments: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
