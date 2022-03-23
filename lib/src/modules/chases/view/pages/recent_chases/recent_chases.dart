import 'package:chaseapp/src/core/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/chases/view/parts/chases_paginatedlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class RecentChasesList extends StatelessWidget {
  RecentChasesList({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
  }) : super(key: key);

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
