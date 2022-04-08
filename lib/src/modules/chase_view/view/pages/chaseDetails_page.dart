import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/chase/chase.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../chats/view/pages/chats_row_view.dart';
import '../../../chats/view/parts/chats_view.dart';
import '../parts/chase_details_page_internal.dart';
import '../providers/providers.dart';

// import 'package:chaseapp/pages/chat_page.dart';
class ChaseDetailsView extends ConsumerStatefulWidget {
  final String chaseId;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;

  const ChaseDetailsView({
    Key? key,
    required this.chaseId,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
  }) : super(key: key);

  @override
  ConsumerState<ChaseDetailsView> createState() => _ChaseDetailsViewState();
}

class _ChaseDetailsViewState extends ConsumerState<ChaseDetailsView> {
  final Logger logger = Logger('ChaseView');

  @override
  Widget build(BuildContext context) {
    final String chaseId = widget.chaseId;

    return ChaseDetailsProviderStateBuilder<Chase>(
      watchThisProvider: streamChaseProvider(chaseId),
      logger: logger,
      showBackButton: true,
      chatsRow: ChatsViewRow(chaseId: chaseId),
      chatsView: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final bool showChatsWindow = ref.watch(isShowingChatsWindowProvide);

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: child,
              );
            },
            child: showChatsWindow ? child : const SizedBox.shrink(),
          );
        },
        child: ChatsView(
          chaseId: chaseId,
        ),
      ),
      builder: (Chase chase, WidgetRef ref, Widget chatsRow, Widget chatsView) {
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
