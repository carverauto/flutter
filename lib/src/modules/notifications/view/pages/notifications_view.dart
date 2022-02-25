import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notifications_list.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
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
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ProviderStateBuilder<List<String?>>(
        watchThisProvider: usersInterestsStreamProvider,
        logger: logger,
        builder: (userInterests) {
          return Column(
            children: [
              SizedBox(
                height: kItemsSpacingMediumConstant,
              ),
              NotificationTypes(
                userInterests: userInterests,
              ),
              Expanded(
                child: NotificationsViewAll(
                  chasesPaginationProvider: notificationsProvider,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NotificationTypes extends ConsumerStatefulWidget {
  NotificationTypes({
    Key? key,
    required this.userInterests,
  }) : super(key: key);

  final List<String?> userInterests;

  @override
  ConsumerState<NotificationTypes> createState() => _NotificationTypesState();
}

class _NotificationTypesState extends ConsumerState<NotificationTypes> {
  bool showCloseButton = false;

  @override
  void initState() {
    super.initState();
    ref.refresh(notificationInterestProvider);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedValue = ref.watch(notificationInterestProvider);

    return TweenAnimationBuilder<Offset>(
        tween: Tween(
            begin: Offset(Sizescaleconfig.screenwidth!, 0), end: Offset.zero),
        duration: Duration(milliseconds: 300),
        child: SizedBox(
            height: 34,
            child: Row(
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
                      color:
                          showCloseButton ? Colors.white : Colors.transparent,
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
                                  .read(notificationInterestProvider.state)
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
                      itemCount: widget.userInterests.length,
                      itemBuilder: (context, index) {
                        final interest = widget.userInterests[index];

                        return NotificationTypeChip(
                            value: interest ?? "NA",
                            selectedValue: selectedValue,
                            onTap: (value) {
                              if (selectedValue != value) {
                                setState(() {
                                  showCloseButton = true;
                                  ref
                                      .read(notificationInterestProvider.state)
                                      .update((state) => value);
                                });
                              } else {
                                setState(() {
                                  showCloseButton = false;
                                  ref
                                      .read(notificationInterestProvider.state)
                                      .update((state) => null);
                                });
                              }
                            });
                      }),
                ),
              ],
            )),
        builder: (context, value, child) {
          return Transform.translate(
            offset: value,
            child: child,
          );
        });
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
              color: selectedValue == value ? Colors.green : null,
              border: Border.all(
                color: Colors.white,
              ),
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
