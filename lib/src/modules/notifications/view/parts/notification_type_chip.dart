import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../const/sizings.dart';

class NotificationTypeChip extends StatelessWidget {
  const NotificationTypeChip({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  final String? selectedValue;
  final String? value;
  final Function(String? value) onTap;

  @override
  Widget build(BuildContext context) {
    final String? displayName = toBeginningOfSentenceCase(value?.split('-')[0]);

    return GestureDetector(
      onTap: () {
        onTap(value);
      },
      child: Opacity(
        opacity: 1, //selectedValue == null || selectedValue == value ? 1 : 0,
        child: Tooltip(
          message: value ?? 'All notifications you are subscribed to.',
          child: AnimatedContainer(
            duration:
                Duration(milliseconds: selectedValue == value ? 300 : 150),
            margin: const EdgeInsets.only(right: kItemsSpacingExtraSmallConstant),
            width:
                100, //selectedValue == null || selectedValue == value ? 100 : 0,
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: kButtonPaddingMedium),
            decoration: BoxDecoration(
              color: selectedValue == value
                  ? Theme.of(context).primaryColorLight
                  : null,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              // following the naming convention of interests names,
              displayName ?? 'All',
              style: const TextStyle(
                color: Colors.white,
                //  selectedValue == null || selectedValue == value
                //     ? Colors.white
                //     : Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
