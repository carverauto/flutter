import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/notifiers/post_login_state_notifier.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notifications_list.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({Key? key}) : super(key: key);

  final Logger logger = Logger('NotificationsView');

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = notificationsStreamProvider(logger);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          NotificationTypes(),
          Expanded(
            child: NotificationsViewAll(
              chasesPaginationProvider: notificationsProvider,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTypes extends StatefulWidget {
  NotificationTypes({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationTypes> createState() => _NotificationTypesState();
}

class _NotificationTypesState extends State<NotificationTypes> {
  bool showCloseButton = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Consumer(builder: (context, ref, child) {
        final selectedValue = ref.watch(notificationTypeIdProvider);

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showCloseButton)
              SizedBox(
                width: kPaddingMediumConstant,
              ),
            AnimatedContainer(
              duration: Duration(
                milliseconds: 150,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: showCloseButton ? Colors.white : Colors.transparent,
                ),
              ),
              alignment: Alignment.center,
              // transitionBuilder: (child, animation) {
              //   return ScaleTransition(
              //     scale: animation,
              //     child: child,
              //   );
              // },
              child: showCloseButton
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          showCloseButton = false;
                          ref
                              .read(notificationTypeIdProvider.state)
                              .update((state) => null);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 150),
              child: SizedBox(
                width: showCloseButton ? 20 : 0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0).copyWith(
                    left: showCloseButton ? 0 : 20,
                  ),
                  itemCount: activeInterests.length,
                  itemBuilder: (context, index) {
                    final interest = activeInterests[index];

                    return NotificationTypeChip(
                        value: interest.name,
                        selectedValue: selectedValue,
                        onTap: (value) {
                          if (selectedValue != value) {
                            setState(() {
                              showCloseButton = true;
                              ref
                                  .read(notificationTypeIdProvider.state)
                                  .update((state) => value);
                            });
                          } else {
                            setState(() {
                              showCloseButton = false;
                              ref
                                  .read(notificationTypeIdProvider.state)
                                  .update((state) => null);
                            });
                          }
                        });
                  }),
            ),
          ],
        );
      }),
    );
  }
}

class NotificationTypeChip extends StatelessWidget {
  const NotificationTypeChip({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  }) : super(key: key);

  final String? selectedValue;
  final String value;
  final Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      child: Opacity(
        opacity: selectedValue == null || selectedValue == value ? 1 : 0,
        child: Tooltip(
          message: value,
          child: AnimatedContainer(
            duration:
                Duration(milliseconds: selectedValue == value ? 300 : 150),
            margin: EdgeInsets.only(right: kItemsSpacingExtraSmallConstant),
            width: selectedValue == null || selectedValue == value ? 100 : 0,
            height: 34,
            padding: EdgeInsets.symmetric(horizontal: kButtonPaddingMedium),
            decoration: BoxDecoration(
              color: selectedValue == value ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              value.substring(0, 1).toUpperCase() +
                  value.substring(1).toLowerCase(),
              style: TextStyle(
                color: selectedValue == null || selectedValue == value
                    ? Colors.white
                    : Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
