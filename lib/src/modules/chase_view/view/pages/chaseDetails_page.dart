import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../models/chase/chase.dart';
import '../../../../shared/util/helpers/request_permissions.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../chats/view/pages/chats_row_view.dart';
import '../../../chats/view/parts/chats_view.dart';
import '../../../chats/view/providers/providers.dart';
import '../parts/chase_details_page_internal.dart';
import '../providers/providers.dart';

// import 'package:chaseapp/pages/chat_page.dart';
class ChaseDetailsView extends ConsumerStatefulWidget {
  const ChaseDetailsView({
    super.key,
    required this.chaseId,
    required this.appBarOffsetAnimation,
    required this.bottomListAnimation,
    required this.chase,
  });
  final String chaseId;
  final Chase? chase;
  final Animation<Offset> appBarOffsetAnimation;
  final Animation<Offset> bottomListAnimation;

  @override
  ConsumerState<ChaseDetailsView> createState() => _ChaseDetailsViewState();
}

class _ChaseDetailsViewState extends ConsumerState<ChaseDetailsView> {
  final Logger logger = Logger('ChaseDetailsView');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      try {
        ref.refresh(chatChannelProvider(widget.chaseId));
        await updateisFirstChaseViewedStatus();
      } catch (e, stk) {
        logger.warning(
          'ChaseDetailsView initialization operations error.',
          e,
          stk,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String chaseId = widget.chaseId;

    // ref.watch(playVideoProvider);
    final ChatsViewRow chatsRow = ChatsViewRow(chaseId: chaseId);
    final ChatsView chatsView = ChatsView(
      chaseId: chaseId,
    );

    return widget.chase != null
        ? ChaseDetailsInternal(
            chase: widget.chase!,
            appBarOffsetAnimation: widget.appBarOffsetAnimation,
            bottomListAnimation: widget.bottomListAnimation,
            logger: logger,
            chatsRow: chatsRow,
            chatsView: chatsView,
          )
        : ChaseDetailsProviderStateBuilder<Chase>(
            watchThisProvider: fetchChaseProvider(chaseId),
            logger: logger,
            showBackButton: true,
            chatsRow: chatsRow,
            chatsView: chatsView,
            builder: (
              Chase chase,
              WidgetRef ref,
              Widget chatsRow,
              Widget chatsView,
            ) {
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
