import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
    this.respectBottomPadding = true,
  }) : super(key: key);
  final String chaseId;
  final Logger logger = Logger('ChatsView');

  bool respectBottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showButton = MediaQuery.of(context).viewInsets.bottom > 0;
    final Channel channel = ref.watch(chatChannelProvider(chaseId));

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            respectBottomPadding ? MediaQuery.of(context).viewInsets.bottom : 0,
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                bottom: 0,
                top: 0,
              ),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(
                    width: kItemsSpacingSmallConstant,
                  ),
                  UsersPresentCount(
                    chaseId: chaseId,
                    logger: logger,
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
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
                            },
                            icon: const Icon(
                              Icons.arrow_downward_outlined,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).focusScopeNode.unfocus();

                      Timer(
                        const Duration(milliseconds: 100),
                        () {
                          ref
                              .read(isShowingChatsWindowProvide.state)
                              .update((bool state) => false);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
            child: const SizedBox(
              height: 2,
              width: double.maxFinite,
            ),
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
              child: StreamChannel(
                channel: channel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: StreamMessageListView(
                        // initialAlignment: 0,
                        loadingBuilder: (BuildContext context) =>
                            const CircularAdaptiveProgressIndicatorWithBg(),
                        errorBuilder: (BuildContext context, Object e) {
                          return ChaseAppErrorWidget(
                            onRefresh: () {
                              ref.refresh(chatWsConnectionStreamProvider);
                            },
                          );
                        },
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.manual,
                      ),
                    ),
                    const RepaintBoundary(
                      child: StreamMessageInput(
                        disableAttachments: true,
                        maxHeight: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UsersPresentCount extends ConsumerStatefulWidget {
  const UsersPresentCount({
    Key? key,
    required this.chaseId,
    required this.logger,
  }) : super(key: key);

  final String chaseId;
  final Logger logger;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UsersPresentCountState();
}

class _UsersPresentCountState extends ConsumerState<UsersPresentCount> {
  late int watchersCount;
  late String? channelId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    channelId = ref.read(chatChannelProvider(widget.chaseId)).id;
    watchersCount =
        ref.read(chatChannelProvider(widget.chaseId)).state?.watcherCount ?? 1;

    ref.read(streamChatClientProvider).eventStream.listen((Event event) {
      if (event.channelId == channelId) {
        final int? updatedCount = event.extraData['watcher_count'] as int?;

        if (updatedCount != null) {
          if (updatedCount != watchersCount) {
            if (mounted) {
              setState(() {
                watchersCount = updatedCount;
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kItemsSpacingSmallConstant,
          vertical: kPaddingXSmallConstant,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.remove_red_eye_rounded,
              size: 18,
            ),
            const SizedBox(
              width: kPaddingXSmallConstant,
            ),
            ref.watch(chatWsConnectionStreamProvider).maybeWhen(
                  orElse: SizedBox.shrink,
                  data: (ConnectionStatus state) {
                    // ignore: prefer-conditional-expressions
                    if (state == ConnectionStatus.connected) {
                      return ProviderStateBuilder<ChannelState>(
                        watchThisProvider: watcherStateProvider(widget.chaseId),
                        logger: widget.logger,
                        loadingBuilder: SizedBox.shrink,
                        errorBuilder: (Object e, StackTrace? stk) =>
                            const Text('NA'),
                        builder: (
                          ChannelState channelState,
                          WidgetRef ref,
                          Widget? child,
                        ) {
                          //TODO: format the count
                          return Text(
                            watchersCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
          ],
        ),
      ),
    );

    //  Chip(
    //   avatar:
    //   label:
    // );
  }
}
