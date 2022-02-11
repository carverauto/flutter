import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/dashboard/view/parts/chases_paginatedlist_view.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class RecentChasesList extends StatelessWidget {
  RecentChasesList({
    Key? key,
    required this.chasesPaingationProvider,
    required this.logger,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<Chase>,
      PaginationNotifierState<Chase>> chasesPaingationProvider;
  final Logger logger;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChasesPaginatedListView(
      chasesPaingationProvider: chasesPaingationProvider,
      logger: logger,
      scrollController: scrollController,
    );
  }
}
