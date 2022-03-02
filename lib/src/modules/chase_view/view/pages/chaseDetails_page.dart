import 'dart:core';

import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chase_view/view/parts/chase_details_page_internal.dart';
import 'package:chaseapp/src/modules/chase_view/view/providers/providers.dart';
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

    return ProviderStateBuilder<Chase>(
      watchThisProvider: streamChaseProvider(chaseId),
      logger: logger,
      showBackButton: true,
      builder: (chase, ref) {
        return ChaseDetailsInternal(
          chase: chase,
          appBarOffsetAnimation: widget.appBarOffsetAnimation,
          bottomListAnimation: widget.bottomListAnimation,
          logger: logger,
        );
      },
    );
  }
}
