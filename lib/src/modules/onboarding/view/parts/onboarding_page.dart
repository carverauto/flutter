import 'dart:ui';

import 'package:chaseapp/src/const/colors.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
import 'package:chaseapp/src/shared/widgets/buttons/glass_button.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          title,
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          Expanded(
            child: Center(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(
                  kPaddingMediumConstant,
                ),
                margin: EdgeInsets.all(
                  kPaddingMediumConstant,
                ).copyWith(
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.shade700.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(
                    kBorderRadiusStandard,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurValue,
                    sigmaY: blurValue,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          GlassButton(
            onTap: onTap,
            padding: EdgeInsets.symmetric(
              horizontal: kPaddingLargeConstant,
              vertical: kPaddingLargeConstant / 2,
            ),
            child: Text(
              pageIndex == 0 ? "Next" : "Continue",
              style: getButtonStyle(context),
            ),
          )
        ],
      ),
    );
  }
}
