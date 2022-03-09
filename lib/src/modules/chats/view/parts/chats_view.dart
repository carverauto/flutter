import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/other.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsView extends ConsumerWidget {
  ChatsView({
    Key? key,
    required this.chaseId,
  }) : super(key: key);
  final String chaseId;
  final Logger logger = Logger('ChatsView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final showButton = bottomPadding > 0;
    return AnimatedPadding(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusStandard),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                blurRadius: blurValue,
                color: primaryShadowColor,
              )
            ]),
        child: Column(
          children: [
            AnimatedPadding(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                  bottom: 0,
                  top: showButton
                      ? kPaddingSmallConstant
                      : kPaddingMediumConstant),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Chats",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  UsersPresentCount(chaseId: chaseId, logger: logger),
                  Spacer(),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
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
                            icon: Icon(
                              Icons.arrow_downward_outlined,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(isShowingChatsWindowProvide.state)
                          .update((state) => false);
                      // Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            Expanded(
              child: ProviderStateBuilder<Channel>(
                watchThisProvider: chatChannelProvider(chaseId),
                logger: logger,
                builder: (channel, ref, child) {
                  return TweenAnimationBuilder<Offset>(
                    tween: Tween<Offset>(
                        begin: Offset(0, MediaQuery.of(context).size.height),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MessageListView(
                              // initialAlignment: 0,
                              loadingBuilder: (context) =>
                                  CircularAdaptiveProgressIndicatorWithBg(),
                              errorBuilder: (context, e) {
                                return ChaseAppErrorWidget(onRefresh: () {
                                  ref.refresh(chatChannelProvider(chaseId));
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
                  );
                },
              ),
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
      avatar: Icon(
        Icons.remove_red_eye_rounded,
        size: 18,
      ),
      label: ref.watch(chatWsConnectionStreamProvider).maybeWhen(
          orElse: () => SizedBox.shrink(),
          data: (state) {
            if (state == ConnectionStatus.connected) {
              return ProviderStateBuilder<Channel>(
                  watchThisProvider: chatChannelProvider(chaseId),
                  logger: logger,
                  loadingBuilder: () => SizedBox.shrink(),
                  errorBuilder: (e, stk) => Text("NA"),
                  builder: (channel, ref, child) {
                    return ProviderStateBuilder<ChannelState>(
                      loadingBuilder: () => SizedBox.shrink(),
                      errorBuilder: (e, stk) => Text("NA"),
                      builder: (channelState, ref, child) {
                        final count = channelState.watcherCount ?? 0;
                        return Text(
                          count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      watchThisProvider: watcherStateProvider(channel),
                      logger: logger,
                    );
                  });
            } else {
              return SizedBox.shrink();
            }
          }),
    );
  }
}
