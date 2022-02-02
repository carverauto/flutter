import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/textstyles.dart';
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
                    "Welcom To ChaseApp!",
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
    return Container(
      padding: EdgeInsets.all(
        kPaddingMediumConstant,
      ),
      margin: EdgeInsets.all(
        kPaddingMediumConstant,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(
          kBorderRadiusSmallConstant,
        ),
      ),
      child: Column(
        children: [
          title,
          SizedBox(
            height: kItemsSpacingSmall,
          ),
          Expanded(
            child: ListView(
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            height: kItemsSpacingSmall,
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
    );
  }
}

const String chaseAppMessage =
    """We have created an exciting platform powered by the chase and live-action news and streaming community and are proud to be the only ones delivering live notifications and links to multiple streaming sources whenever a live police pursuit occurs anywhere in the world.""";

const String nodleUsageMessage =
    """ This version of ChaseApp is supported by Nodle. Your smartphones Bluetooth connection and Location services are used while you're browsing ChaseApp to enable a crowdsourced IoT network. There is no personal data captured, and it uses very low bandwidth. We earn a small fee for this that helps cover our costs and you see no advertisements and pay nothing.\n\nThere are millions of these IoT devices everywhere, and they need to send small messages periodically; devices like your gas meter, Apple tags, and there will be billions more.""";
