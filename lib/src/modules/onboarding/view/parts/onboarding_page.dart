import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
    required this.title,
    required this.message,
    required this.onTap,
    required this.pageIndex,
  }) : super(key: key);

  final Widget title;
  final String message;
  final VoidCallback onTap;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(
          kPaddingMediumConstant,
        ),
        margin: EdgeInsets.all(
          kPaddingMediumConstant,
        ).copyWith(
          bottom: 0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(
            kBorderRadiusSmallConstant,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            SizedBox(
              height: kItemsSpacingSmall,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            SizedBox(
              height: kItemsSpacingMediumConstant,
            ),
            ElevatedButton(
              onPressed: onTap,
              style: callToActionButtonStyle,
              child: Text(
                pageIndex == 0 ? "Next" : "Continue",
                style: getButtonStyle(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
