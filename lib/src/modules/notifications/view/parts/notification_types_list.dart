import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_type_chip.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
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
                    color: showCloseButton ? Colors.white : Colors.transparent,
                  ),
                ),
                alignment: Alignment.center,
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
    );
  }
}
