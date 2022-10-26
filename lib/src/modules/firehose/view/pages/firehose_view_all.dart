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

class FirehoseListViewAll extends ConsumerStatefulWidget {
  const FirehoseListViewAll({
    Key? key,
    required this.showLimited,
  }) : super(key: key);

  final bool showLimited;

  @override
  ConsumerState<FirehoseListViewAll> createState() =>
      _FirehoseListViewAllState();
}

class _FirehoseListViewAllState extends ConsumerState<FirehoseListViewAll>
    with WidgetsBindingObserver {
  late final AutoDisposeStateNotifierProvider<
      PaginationNotifier<ChaseAppNotification>,
      PaginationNotifierState<ChaseAppNotification>> itemsProvider;
  late final Logger logger;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logger = Logger('FirehoseListViewAll');
    itemsProvider = firehosePaginatedStateNotifierProvier(logger);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      switch (state) {
        case AppLifecycleState.resumed:
          ref.refresh(firehosePaginatedStateNotifierProvier(logger));
          break;
        default:
      }
      // if (state == AppLifecycleState.resumed) {
      //   _timerLink = Timer(
      //     const Duration(milliseconds: 1000),
      //     () {},
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showLimited
        ? SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: kPaddingMediumConstant),
            sliver: FireHoseView(
              itemsPaginationProvider: itemsProvider,
              showLimited: widget.showLimited,
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
              showLimited: widget.showLimited,
              scrollController: controller,
              logger: logger,
            ),
          );
  }
}
