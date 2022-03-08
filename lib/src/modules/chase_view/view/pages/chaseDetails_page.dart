import 'dart:core';

import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_details_page_internal.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
import 'package:chaseapp/src/modules/chats/view/pages/chats_row_view.dart';
import 'package:chaseapp/src/modules/chats/view/parts/chats_view.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

// import 'package:chaseapp/pages/chat_page.dart';
class ChaseDetailsView extends ConsumerStatefulWidget {
  final String chaseId;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;

  ChaseDetailsView({
    Key? key,
    required this.chaseId,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
  }) : super(key: key);

  @override
  ConsumerState<ChaseDetailsView> createState() => _ChaseDetailsViewState();
}

class _ChaseDetailsViewState extends ConsumerState<ChaseDetailsView> {
  final Logger logger = Logger("ChaseView");

  @override
  Widget build(BuildContext context) {
    final chaseId = widget.chaseId;

    ref.watch(playVideoProvider);

    return ChaseDetailsProviderStateBuilder<Chase>(
      watchThisProvider: streamChaseProvider(chaseId),
      logger: logger,
      showBackButton: true,
      chatsRow: ChatsViewRow(chaseId: chaseId),
      chatsView: Consumer(
        child: ChatsView(
          chaseId: chaseId,
        ),
        builder: ((context, ref, child) {
          final showChatsWindow = ref.watch(isShowingChatsWindowProvide);
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0),
                ).animate(animation),
                child: child,
              );
            },
            child: showChatsWindow ? child : SizedBox.shrink(),
          );
        }),
      ),
      builder: (chase, ref, chatsRow, chatsView) {
        return ChaseDetailsInternal(
          chase: chase,
          appBarOffsetAnimation: widget.appBarOffsetAnimation,
          bottomListAnimation: widget.bottomListAnimation,
          logger: logger,
          chatsRow: chatsRow,
          chatsView: chatsView,
        );
      },
    );
  }
}
