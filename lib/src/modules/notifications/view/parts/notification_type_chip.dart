import 'package:chaseapp/src/const/sizings.dart';
import 'package:flutter/material.dart';

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
