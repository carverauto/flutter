import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/parts/firehose_short_view.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FireHoseView extends ConsumerWidget {
  FireHoseView({Key? key}) : super(key: key);

  final Logger _logger = Logger('FireHoseView');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<ChaseAppNotification>(
      scrollController: ScrollController(),
      axis: Axis.vertical,
      builder: (notifications, ref) {
        return SliverToBoxAdapter(
          child: FirehoseShortView(
            notifications: notifications,
          ),
        );
      },
      watchThisStateNotifierProvider:
          firehoseNotificationsStreamProvider(_logger),
      logger: _logger,
    );
  }
}
