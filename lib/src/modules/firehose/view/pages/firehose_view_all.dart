import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../../../../const/sizings.dart';
import '../../../../core/notifiers/pagination_notifier.dart';
import '../../../../models/notification/notification.dart';
import '../../../../models/pagination_state/pagination_notifier_state.dart';
import '../../../../shared/widgets/builders/SliverPaginatedListViewAll.dart';
import '../providers/providers.dart';
import 'firehose.dart';

class FirehoseListViewAll extends StatelessWidget {
  FirehoseListViewAll({
    Key? key,
    required this.showLimited,
  }) : super(key: key);

  final Logger logger = Logger('FirehoseListViewAll');

  final bool showLimited;

  @override
  Widget build(BuildContext context) {
    final AutoDisposeStateNotifierProvider<
            PaginationNotifier<ChaseAppNotification>,
            PaginationNotifierState<ChaseAppNotification>> itemsProvider =
        firehosePaginatedStateNotifierProvier(logger);

    return showLimited
        ? SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
            sliver: FireHoseView(
              itemsPaginationProvider: itemsProvider,
              showLimited: showLimited,
              scrollController: ScrollController(),
              logger: logger,
            ),
          )
        : SliversPaginatedListViewAll<ChaseAppNotification>(
            itemsPaginationProvider:
                firehosePaginatedStateNotifierProvier(logger),
            title: 'Firehose',
            logger: logger,
            builder: (
              ScrollController controller,
              AutoDisposeStateNotifierProvider<
                      PaginationNotifier<ChaseAppNotification>,
                      PaginationNotifierState<ChaseAppNotification>>
                  itemsPaginationProvider,
            ) =>
                FireHoseView(
              itemsPaginationProvider: itemsProvider,
              showLimited: showLimited,
              scrollController: controller,
              logger: logger,
            ),
          );
  }
}
