import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../core/notifiers/pagination_notifier.dart';
import '../../../../../models/chase/chase.dart';
import '../../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../parts/chases_paginatedlist_view.dart';

class RecentChasesList extends StatelessWidget {
  RecentChasesList({
    super.key,
    required this.chasesPaginationProvider,
    required this.logger,
  });

  final AutoDisposeStateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChasesPaginatedListView(
      chasesPaginationProvider: chasesPaginationProvider,
      logger: logger,
      scrollController: scrollController,
    );
  }
}
