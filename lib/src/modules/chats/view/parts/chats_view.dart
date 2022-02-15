import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({
    Key? key,
    required this.chase,
  }) : super(key: key);
  final Chase chase;

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Consumer(builder: (context, ref, _) {
                  final state = ref.watch(chatChannelProvider(chase));
                  return state.when(
                      data: (channel) {
                        return TweenAnimationBuilder<Offset>(
                          tween: Tween<Offset>(
                              begin:
                                  Offset(0, MediaQuery.of(context).size.height),
                              end: Offset.zero),
                          curve: Curves.decelerate,
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
                                        ScrollViewKeyboardDismissBehavior
                                            .manual,
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
                      loading: () => CircularAdaptiveProgressIndicatorWithBg(),
                      error: (e, stk) {
                        return ChaseAppErrorWidget(onRefresh: () {
                          ref.refresh(chatChannelProvider(chase));
                        });
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
