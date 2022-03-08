import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/other.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
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
    required this.chase,
  }) : super(key: key);
  final Chase chase;
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
                  UsersPresentCount(chase: chase, logger: logger),
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
                watchThisProvider: chatChannelProvider(chase),
                logger: logger,
                builder: (channel, ref) {
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
                                  ref.refresh(chatChannelProvider(chase));
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
    required this.chase,
    required this.logger,
  }) : super(key: key);

  final Chase chase;
  final Logger logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chip(
      avatar: Icon(
        Icons.remove_red_eye_rounded,
        size: 18,
      ),
      label: ProviderStateBuilder<Channel>(
          watchThisProvider: chatChannelProvider(chase),
          logger: logger,
          loadingBuilder: () => SizedBox.shrink(),
          errorBuilder: (e, stk) => Text("NA"),
          builder: (channel, ref) {
            return ProviderStateBuilder(
              loadingBuilder: () => SizedBox.shrink(),
              errorBuilder: (e, stk) => Text("NA"),
              builder: (count, ref) {
                return Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              watchThisProvider: watcherCountProvider(channel),
              logger: logger,
            );
          }),
    );
  }
}
