import 'package:chaseapp/src/const/aspect_ratio.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:chaseapp/src/shared/widgets/builders/image_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;

  bool activateContinueButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: kItemsSpacingLarge,
          ),
          Expanded(
            child: PageView.builder(
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                    if (index == 2) activateContinueButton = true;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get live events of exclusive chases on app.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Spacer(),
                      Placeholder(),
                      Spacer(),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: kItemsSpacingMedium,
          ),
          AnimatingWalletsDots(
            pageIndex: pageIndex,
          ),
          SizedBox(
            height: kItemsSpacingMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(
              kPaddingMediumConstant,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(
                    kButtonHeightSmall,
                  ),
                  maximumSize: Size.fromHeight(
                    kButtonHeightLarge,
                  )),
              onPressed: !activateContinueButton
                  ? null
                  : () {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                      );
                    },
              child: Text(
                "Continue",
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AnimatingWalletsDots extends StatelessWidget {
  const AnimatingWalletsDots({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  final pageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: const EdgeInsets.only(right: 5),
            height: Sizescaleconfig.scaleHeightFactorWithMaxMinConstraints(
              kPaddingSmallConstant,
              kPaddingMediumConstant,
              kPaddingSmallConstant,
            ),
            width: Sizescaleconfig.scaleHeightFactorWithMaxMinConstraints(
              pageIndex == i ? kPaddingMediumConstant : kPaddingSmallConstant,
              kPaddingMediumConstant,
              kPaddingSmallConstant,
            ),
            decoration: BoxDecoration(
              color: pageIndex == i
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(8),
            ),
          )
      ],
    );
  }
}
