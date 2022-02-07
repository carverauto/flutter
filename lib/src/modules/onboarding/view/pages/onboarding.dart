import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/info.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/modules/onboarding/view/parts/onboarding_page.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Column(
        children: [
          SizedBox(
            height: kItemsSpacingLarge,
          ),
          Image.asset(
            chaseAppNameImage,
            height: kImageSizeLarge,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              padEnds: true,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                  if (index == 1) activateContinueButton = true;
                });
              },
              children: [
                OnboardingPage(
                  title: Text(
                    "Welcome To ChaseApp!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  message: chaseAppMessage,
                  onTap: () {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                    );
                  },
                  pageIndex: pageIndex,
                ),
                OnboardingPage(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Powered by",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      SizedBox(
                        width: kItemsSpacingSmallConstant,
                      ),
                      SvgPicture.asset(
                        "assets/icon/nodle.svg",
                        height: kIconSizeMediumConstant,
                      ),
                    ],
                  ),
                  message: nodleUsageMessage,
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                    );
                  },
                  pageIndex: pageIndex,
                ),
              ],
            ),
          ),
          SizedBox(
            height: kItemsSpacingMedium,
          ),
        ],
      ),
    );
  }
}
