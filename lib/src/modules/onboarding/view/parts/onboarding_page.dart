import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../const/colors.dart';
import '../../../../const/sizings.dart';
import '../../../../const/textstyles.dart';
import '../../../../shared/util/helpers/sizescaleconfig.dart';

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
          const SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          title,
          const SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          Expanded(
            child: Center(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(
                  kPaddingMediumConstant,
                ),
                margin: const EdgeInsets.all(
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
                    padding: const EdgeInsets.all(0),
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizescaleconfig.getDeviceType ==
                                  DeviceType.TABLET
                              ? Theme.of(context).textTheme.headline6!.fontSize
                              : Theme.of(context).textTheme.subtitle1!.fontSize,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kItemsSpacingMediumConstant,
          ),
          Divider(
            color: primaryColor.shade700,
            height: 0,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: Text(
                  // pageIndex == 0 ? "Next" :
                  'Continue',
                  style: getButtonStyle(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
