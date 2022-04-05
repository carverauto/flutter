import 'dart:developer';

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
import '../providers/providers.dart';

class ChatsView extends ConsumerWidget {
  ChatsView({
    Key? key,
    required this.chaseId,
  }) : super(key: key);
  final String chaseId;
  final Logger logger = Logger('ChatsView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final bool showButton = bottomPadding > 0;
    log(bottomPadding.toString());
    final Channel channel = ref.watch(chatChannelProvider(chaseId));

    return Padding(
      // duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusStandard),
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
            BoxShadow(
              blurRadius: blurValue,
              color: primaryShadowColor,
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              //  duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                bottom: 0,
                top:
                    showButton ? kPaddingSmallConstant : kPaddingMediumConstant,
              ),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  RepaintBoundary(
                    child: UsersPresentCount(
                      chaseId: chaseId,
                      logger: logger,
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: showButton
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context).focusScopeNode.unfocus();
                              // Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_downward_outlined,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(isShowingChatsWindowProvide.state)
                          .update((bool state) => false);
                      // Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 2,
            ),
            Expanded(
              child: TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(
                  begin: Offset(0, MediaQuery.of(context).size.height),
                  end: Offset.zero,
                ),
                curve: kPrimaryCurve,
                duration: const Duration(milliseconds: 300),
                builder: (BuildContext context, Offset value, Widget? child) {
                  return Transform.translate(
                    offset: value,
                    child: child,
                  );
                },
                child: StreamChat(
                  streamChatThemeData: StreamChatThemeData.dark().copyWith(
                    // TODO: Need to debug why?
                    // If not added at the root of the app then getStream API is overriding the
                    // the user set accentColor in Custom Theme
                    colorTheme: ColorTheme.dark(
                      accentPrimary: kPrimaryAccent,
                    ),
                  ),
                  client: ref.watch(streamChatClientProvider),
                  child: StreamChannel(
                    channel: channel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: MessageListView(
                            // initialAlignment: 0,
                            loadingBuilder: (BuildContext context) =>
                                const CircularAdaptiveProgressIndicatorWithBg(),
                            errorBuilder: (BuildContext context, Object e) {
                              return ChaseAppErrorWidget(
                                onRefresh: () {
                                  ref.refresh(chatChannelProvider(chaseId));
                                },
                              );
                            },
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.manual,
                          ),
                        ),
                        const RepaintBoundary(
                          child: MessageInput(
                            disableAttachments: true,
                            maxHeight: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //  ProviderStateBuilder<Channel>(
              //   watchThisProvider: chatChannelProvider(chaseId),
              //   logger: logger,
              //   builder: (Channel channel, WidgetRef ref, Widget? child) {
              //     return TweenAnimationBuilder<Offset>(
              //       tween: Tween<Offset>(
              //         begin: Offset(0, MediaQuery.of(context).size.height),
              //         end: Offset.zero,
              //       ),
              //       curve: kPrimaryCurve,
              //       duration: const Duration(milliseconds: 300),
              //       builder:
              //           (BuildContext context, Offset value, Widget? child) {
              //         return Transform.translate(
              //           offset: value,
              //           child: child,
              //         );
              //       },
              //       child: StreamChannel(
              //         channel: channel,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Expanded(
              //               child: MessageListView(
              //                 // initialAlignment: 0,
              //                 loadingBuilder: (BuildContext context) =>
              //                     const CircularAdaptiveProgressIndicatorWithBg(),
              //                 errorBuilder: (BuildContext context, Object e) {
              //                   return ChaseAppErrorWidget(
              //                     onRefresh: () {
              //                       ref.refresh(chatChannelProvider(chaseId));
              //                     },
              //                   );
              //                 },
              //                 keyboardDismissBehavior:
              //                     ScrollViewKeyboardDismissBehavior.manual,
              //               ),
              //             ),
              //             const RepaintBoundary(
              //               child: MessageInput(
              //                 disableAttachments: true,
              //                 maxHeight: 100,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersPresentCount extends ConsumerWidget {
  const UsersPresentCount({
    Key? key,
    required this.chaseId,
    required this.logger,
  }) : super(key: key);

  final String chaseId;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chip(
      avatar: const Icon(
        Icons.remove_red_eye_rounded,
        size: 18,
      ),
      label: ref.watch(chatWsConnectionStreamProvider).maybeWhen(
            orElse: SizedBox.shrink,
            data: (ConnectionStatus state) {
              // ignore: prefer-conditional-expressions
              if (state == ConnectionStatus.connected) {
                return ProviderStateBuilder<ChannelState>(
                  watchThisProvider: watcherStateProvider(chaseId),
                  logger: logger,
                  loadingBuilder: SizedBox.shrink,
                  errorBuilder: (Object e, StackTrace? stk) => const Text('NA'),
                  builder: (
                    ChannelState channelState,
                    WidgetRef ref,
                    Widget? child,
                  ) {
                    final int count = channelState.watcherCount ?? 0;

                    return Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                    // return ProviderStateBuilder<ChannelState>(
                    //   loadingBuilder: SizedBox.shrink,
                    //   errorBuilder: (Object e, StackTrace? stk) =>
                    //       const Text('NA'),
                    //   builder: (
                    //     ChannelState channelState,
                    //     WidgetRef ref,
                    //     Widget? child,
                    //   ) {
                    //     final int count = channelState.watcherCount ?? 0;

                    //     return Text(
                    //       count.toString(),
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     );
                    //   },
                    //   watchThisProvider: watcherStateProvider(channel),
                    //   logger: logger,
                    // );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
    );
  }
}
