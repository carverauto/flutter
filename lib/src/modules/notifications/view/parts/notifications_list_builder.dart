import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/notification_data/notification_data.dart';
import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_dialog.dart';
import 'package:chaseapp/src/notifiers/pagination_notifier.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/extensions/interest_enum.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:chaseapp/src/shared/widgets/builders/SliverProviderPaginatedStateNotifierBuilder.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:chaseapp/src/shared/widgets/hero_dialog_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsPaginatedListView extends ConsumerWidget {
  NotificationsPaginatedListView({
    Key? key,
    required this.chasesPaginationProvider,
    required this.logger,
    required this.scrollController,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final StateNotifierProvider<PaginationNotifier<NotificationData>,
      PaginationNotifierState<NotificationData>> chasesPaginationProvider;
  final Logger logger;
  final ScrollController scrollController;

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverProviderPaginatedStateNotifierBuilder<NotificationData>(
        watchThisStateNotifierProvider: chasesPaginationProvider,
        logger: logger,
        scrollController: scrollController,
        axis: axis,
        builder: (notifications, controller, [Widget? bottomWidget]) {
          return notifications.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                      ),
                      Chip(
                        label: Text("No Notifications!"),
                      ),
                    ],
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        onTap: () {
                          switch (
                              notifications[index].getInterestEnumFromName) {
                            case Interests.chasesnotifications:
                              Navigator.pushNamed(
                                context,
                                RouteName.CHASE_VIEW,
                                arguments: <String, dynamic>{
                                  "chaseId": notifications[index].data?["id"],
                                },
                              );
                              break;
                            default:
                              Navigator.push(
                                context,
                                HeroDialogRoute<void>(
                                  builder: (context) {
                                    return NotificationDialog(
                                      notificationData: notifications[index],
                                    );
                                  },
                                ),
                              );
                          }
                        },
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Hero(
                              tag: notifications[index].id,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryShadowColor,
                                      blurRadius: blurValue,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  color: Theme.of(context).cardColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  clipBehavior: Clip.hardEdge,
                                  child: AdaptiveImageBuilder(
                                    url: parseImageUrl(
                                      notifications[index].image ??
                                          defaultPhotoURL,
                                      ImageDimensions.SMALL,
                                    ),
                                    //  notifications[index].image ??
                                    //     defaultPhotoURL,
                                    showLoading: false,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(notifications[index].title ?? "NA",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                notifications[index].body ?? "NA",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryColor.shade300,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: kItemsSpacingExtraSmallConstant,
                            ),
                            Text(
                              elapsedTimeForDate(
                                  notifications[index].createdAt),
                              style: TextStyle(
                                color: primaryColor.shade300,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: notifications.length,
                  ),
                );
        });
  }
}
