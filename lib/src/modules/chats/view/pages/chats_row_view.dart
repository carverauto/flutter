import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/colors.dart';
import '../../../../const/other.dart';
import '../../../../const/sizings.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../shared/widgets/errors/error_widget.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import '../../../chase_view/view/providers/providers.dart';
import '../parts/chats_view.dart';
import '../providers/providers.dart';

class ChatsViewRow extends ConsumerWidget {
  ChatsViewRow({
    Key? key,
    required this.chaseId,
  }) : super(key: key);

  final String chaseId;
  final Logger logger = Logger('Chats Section');

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
                await Future<void>.delayed(const Duration(milliseconds: 100));
                ref
                    .read(isShowingChatsWindowProvide.state)
                    .update((bool state) => true);
                // showChatsViewBottomSheet(context, chase);
              },
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          //     decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  UsersPresentCount(chaseId: chaseId, logger: logger),
                  const Spacer(),
                  const Icon(
                    Icons.expand,
                  ),
                ],
              ),
            ),
          ),
          RepaintBoundary(
            child: ProviderStateBuilder<ConnectionStatus>(
              watchThisProvider: chatWsConnectionStreamProvider,
              logger: logger,
              builder: (
                Object? connectionStatus,
                WidgetRef ref, [
                Widget? child,
              ]) {
                switch (connectionStatus) {
                  case ConnectionStatus.connected:
                    return ProviderStateBuilder<ChannelState>(
                      builder: (
                        ChannelState channelState,
                        WidgetRef ref,
                        Widget? child,
                      ) {
                        final Channel channel =
                            ref.watch(chatChannelProvider(chaseId));
                        final List<Message>? messages = channel.state?.messages;
                        if (messages == null || messages.isEmpty) {
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(isShowingChatsWindowProvide.state)
                                  .update((bool state) => true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No chats yet',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final Message lastMessage = messages.last;

                        return TweenAnimationBuilder<Offset>(
                          tween: Tween<Offset>(
                            begin:
                                Offset(0, MediaQuery.of(context).size.height),
                            end: Offset.zero,
                          ),
                          curve: kPrimaryCurve,
                          duration: const Duration(milliseconds: 300),
                          builder: (
                            BuildContext context,
                            Offset value,
                            Widget? child,
                          ) {
                            return Transform.translate(
                              offset: value,
                              child: child,
                            );
                          },
                          child: StreamChannel(
                            channel: ref.read(chatChannelProvider(chaseId)),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () async {
                                await Future<void>.delayed(
                                  const Duration(milliseconds: 100),
                                );
                                ref
                                    .read(isShowingChatsWindowProvide.state)
                                    .update((bool state) => true);
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
                                        lastMessage.user?.name[0]
                                                .toUpperCase() ??
                                            'U',
                                        style: const TextStyle(
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
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      },
                      watchThisProvider: watcherStateProvider(chaseId),
                      logger: logger,
                    );

                  // }

                  //  ProviderStateBuilder<Channel>(
                  //   watchThisProvider: chatChannelProvider(chaseId),
                  //   logger: logger,
                  //   builder: (Channel channel, WidgetRef ref, Widget? child) {
                  //     // channel.watch();
                  //     final List<Message>? messages = channel.state?.messages;
                  //     if (messages == null || messages.isEmpty) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           ref
                  //               .read(isShowingChatsWindowProvide.state)
                  //               .update((bool state) => true);

                  //           // showChatsViewBottomSheet(context, chase);
                  //         },
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               'No chats yet',
                  //               style: TextStyle(
                  //                 color: Theme.of(context)
                  //                     .colorScheme
                  //                     .onBackground,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }

                  //     final Message lastMessage =
                  //         channel.state!.messages.last;

                  //     return TweenAnimationBuilder<Offset>(
                  //       tween: Tween<Offset>(
                  //         begin:
                  //             Offset(0, MediaQuery.of(context).size.height),
                  //         end: Offset.zero,
                  //       ),
                  //       curve: kPrimaryCurve,
                  //       duration: const Duration(milliseconds: 300),
                  //       builder: (
                  //         BuildContext context,
                  //         Offset value,
                  //         Widget? child,
                  //       ) {
                  //         return Transform.translate(
                  //           offset: value,
                  //           child: child,
                  //         );
                  //       },
                  //       child: StreamChannel(
                  //         channel: channel,
                  //         child: ListTile(
                  //           contentPadding: const EdgeInsets.all(0),
                  //           onTap: () async {
                  //             await Future<void>.delayed(
                  //               const Duration(milliseconds: 100),
                  //             );
                  //             ref
                  //                 .read(isShowingChatsWindowProvide.state)
                  //                 .update((bool state) => true);
                  //           },
                  //           leading: CircleAvatar(
                  //             backgroundColor:
                  //                 Theme.of(context).primaryColorLight,
                  //             backgroundImage: lastMessage.user!.image == null
                  //                 ? null
                  //                 : CachedNetworkImageProvider(
                  //                     lastMessage.user!.image!,
                  //                   ),
                  //             child: lastMessage.user!.image != null
                  //                 ? null
                  //                 : Text(
                  //                     lastMessage.user?.name[0]
                  //                             .toUpperCase() ??
                  //                         'U',
                  //                     style: const TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //           ),
                  //           title: Text(
                  //             lastMessage.user!.name,
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .subtitle1!
                  //                 .copyWith(
                  //                   color: Theme.of(context)
                  //                       .colorScheme
                  //                       .onBackground,
                  //                 ),
                  //           ),
                  //           subtitle: lastMessage.text != null
                  //               ? Text(
                  //                   lastMessage.text!,
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .subtitle2!
                  //                       .copyWith(
                  //                         color: primaryColor.shade300,
                  //                       ),
                  //                 )
                  //               : const SizedBox.shrink(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );

                  case ConnectionStatus.connecting:
                    return Column(
                      children: [
                        Text(
                          'Connecting...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(
                          height: kItemsSpacingSmallConstant,
                        ),
                        const CircularAdaptiveProgressIndicatorWithBg(),
                      ],
                    );
                  case ConnectionStatus.disconnected:
                    return ChaseAppErrorWidget(
                      message: 'Unable to connect chats. Try again.',
                      onRefresh: () {
                        ref.refresh(chatChannelProvider(chaseId));
                      },
                    );
                  default:
                    return const CircularAdaptiveProgressIndicatorWithBg();
                }
              },
            ),
          ),
          const SizedBox(
            height: kItemsSpacingLargeConstant,
          ),
        ],
      ),
    );
  }
}
