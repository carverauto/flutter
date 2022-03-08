import 'package:chaseapp/src/models/notification/notification.dart';
import 'package:chaseapp/src/modules/firehose/view/pages/firehose.dart';
import 'package:chaseapp/src/modules/firehose/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverPaginatedListViewAll.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FirehoseListViewAll extends StatelessWidget {
  FirehoseListViewAll({Key? key, this.viewAll = false}) : super(key: key);

  final Logger logger = Logger("FirehoseListViewAll");
  final bool viewAll;

  @override
  Widget build(BuildContext context) {
    return SliversPaginatedListViewAll<ChaseAppNotification>(
      itemsPaginationProvider: firehoseNotificationsStreamProvider(logger),
      title: "Firehose",
      logger: logger,
      builder: (controller) => FireHoseView(
        viewAll: viewAll,
      ),
    );
  }
}
