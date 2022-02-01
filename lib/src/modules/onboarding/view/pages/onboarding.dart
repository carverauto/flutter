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

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          children: [
            SizedBox(
              height: kItemsSpacingLarge,
            ),
            Expanded(
              child: PageView.builder(
                  controller: pageController,
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
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // fontSize: Sizescaleconfig.scalehightfactor(
                                    //   28,
                                    // ),
                                  ),
                        ),
                        SizedBox(
                          height: kItemsSpacingSmall,
                        ),
                        Expanded(
                          child: Placeholder(),
                        ),
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: kItemsSpacingMedium,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (pageIndex != 0)
                  TextButton(
                    onPressed: () {
                      pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(),
                    ),
                    child: Text("Prev"),
                  ),
                Spacer(),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: pageIndex == 2
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                            );
                          },
                          style: TextButton.styleFrom(),
                          child: Text("Continue"),
                        )
                      : TextButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                          style: TextButton.styleFrom(
                            side: BorderSide(),
                          ),
                          child: Text("Next"),
                        ),
                ),
              ],
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size.fromHeight(
            //       kButtonHeightSmall,
            //     ),
            //     fixedSize:
            //         Size.fromHeight(Sizescaleconfig.screenheight! * 0.08),
            //     maximumSize: Size.fromHeight(
            //       kButtonHeightLarge,
            //     ),
            //   ),
            //   onPressed: !activateContinueButton
            //       ? null
            //       : () {
            //           Navigator.pushReplacementNamed(
            //             context,
            //             RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
            //           );
            //         },
            //   child: Text(
            //     "Continue",
            //     style: Theme.of(context).textTheme.headline5!.copyWith(
            //           color: Theme.of(context).colorScheme.onPrimary,
            //         ),
            //   ),
            // )
          ],
        ),
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
            margin: EdgeInsets.all(
              kItemsSpacingSmallConstant,
            ),
            height: Sizescaleconfig.scaleHeightFactorWithMaxMinConstraints(
              kPaddingSmallConstant,
              kPaddingMediumConstant,
              kPaddingSmallConstant,
            ),
            width: Sizescaleconfig.scaleHeightFactorWithMaxMinConstraints(
              pageIndex == i
                  ? kPaddingMediumConstant * 2
                  : kPaddingSmallConstant,
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
