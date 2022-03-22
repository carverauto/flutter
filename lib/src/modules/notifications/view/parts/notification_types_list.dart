import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';
import '../providers/providers.dart';
import 'notification_type_chip.dart';

class NotificationTypes extends ConsumerStatefulWidget {
  const NotificationTypes({
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? selectedValue = ref.watch(notificationInterestProvider);

    return TweenAnimationBuilder<Offset>(
      tween: Tween(
        begin: Offset(Sizescaleconfig.screenwidth!, 0),
        end: Offset.zero,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: SizedBox(
        height: 34,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingMediumConstant,
          ),
          itemCount: widget.userInterests.length,
          itemBuilder: (BuildContext context, int index) {
            final String? interest = widget.userInterests[index];

            return NotificationTypeChip(
              value: interest,
              selectedValue: selectedValue,
              onTap: (String? value) {
                if (selectedValue != value) {
                  setState(() {
                    showCloseButton = true;
                    ref
                        .read(notificationInterestProvider.state)
                        .update((String? state) => value);
                  });
                } else {
                  setState(() {
                    showCloseButton = false;
                    ref
                        .read(notificationInterestProvider.state)
                        .update((String? state) => null);
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
