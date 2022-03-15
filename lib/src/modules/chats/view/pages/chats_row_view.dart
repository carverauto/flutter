import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/other.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/modules/chats/view/parts/chats_view.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsViewRow extends ConsumerWidget {
  ChatsViewRow({
    Key? key,
    required this.chaseId,
  }) : super(key: key);

  final String chaseId;
  final logger = Logger("Chats Section");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMediumConstant,
        vertical: kItemsSpacingSmallConstant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            child: InkWell(
              onTap: () async {
                await Future<void>.delayed(Duration(milliseconds: 100));
                ref
                    .read(isShowingChatsWindowProvide.state)
                    .update((state) => true);
                // showChatsViewBottomSheet(context, chase);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Chats",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          //     decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  UsersPresentCount(chaseId: chaseId, logger: logger),
                  Spacer(),
                  Icon(
                    Icons.expand,
                  ),
                ],
              ),
            ),
          ),
          ProviderStateBuilder(
            builder: (connectionStatus, ref, [child]) {
              switch (connectionStatus) {
                case ConnectionStatus.connected:
                  return ProviderStateBuilder<Channel>(
                    watchThisProvider: chatChannelProvider(chaseId),
                    logger: logger,
                    builder: (channel, ref, child) {
                      // channel.watch();
                      final messages = channel.state?.messages;
                      if (messages == null || messages.isEmpty)
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(isShowingChatsWindowProvide.state)
                                .update((state) => true);

                            // showChatsViewBottomSheet(context, chase);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No chats yet",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ],
                          ),
                        );

                      final lastMessage = channel.state!.messages.last;
                      return TweenAnimationBuilder<Offset>(
                        tween: Tween<Offset>(
                            begin:
                                Offset(0, MediaQuery.of(context).size.height),
                            end: Offset.zero),
                        curve: kPrimaryCurve,
                        duration: Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: value,
                            child: child,
                          );
                        },
                        child: StreamChannel(
                          channel: channel,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            onTap: () async {
                              await Future<void>.delayed(
                                  Duration(milliseconds: 100));
                              ref
                                  .read(isShowingChatsWindowProvide.state)
                                  .update((state) => true);
                            },
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              backgroundImage: lastMessage.user!.image == null
                                  ? null
                                  : CachedNetworkImageProvider(
                                      lastMessage.user!.image!,
                                    ),
                              child: lastMessage.user!.image != null
                                  ? null
                                  : Text(
                                      lastMessage.user?.name[0].toUpperCase() ??
                                          "U",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            title: Text(
                              lastMessage.user!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                            subtitle: lastMessage.text != null
                                ? Text(
                                    lastMessage.text!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .copyWith(
                                          color: primaryColor.shade300,
                                        ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                  );

                case ConnectionStatus.connecting:
                  return Column(
                    children: [
                      Text(
                        "Connecting...",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(
                        height: kItemsSpacingSmallConstant,
                      ),
                      CircularAdaptiveProgressIndicatorWithBg(),
                    ],
                  );
                case ConnectionStatus.disconnected:
                  return ChaseAppErrorWidget(
                      message: "Unable to connect chats. Try again.",
                      onRefresh: () {
                        ref.refresh(chatChannelProvider(chaseId));
                      });
                default:
                  return CircularAdaptiveProgressIndicatorWithBg();
              }
            },
            watchThisProvider: chatWsConnectionStreamProvider,
            logger: logger,
          ),
          SizedBox(
            height: kItemsSpacingLargeConstant,
          ),
        ],
      ),
    );
  }
}
