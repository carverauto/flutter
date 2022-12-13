import 'package:flutter/material.dart';

import '../../../../const/images.dart';
import '../../../../const/info.dart';
import '../../../../const/sizings.dart';
import '../../../../routes/routeNames.dart';
import '../../../../shared/widgets/brand/chaseapp_brand_widgets.dart';
import '../parts/onboarding_page.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  defaultAssetChaseImage,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: kItemsSpacingLarge,
              ),
              const ChaseAppNameLogoImage(),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  children: [
                    OnboardingPage(
                      title: Column(
                        children: [
                          Text(
                            'Welcome To ChaseApp!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        ],
                      ),
                      message: chaseAppMessage,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                        );
                        // pageController.nextPage(
                        //   duration: const Duration(milliseconds: 300),
                        //   curve: Curves.linear,
                        // );
                      },
                      pageIndex: pageIndex,
                    ),
                    // OnboardingPage(
                    //   title: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Powered by",
                    //         textAlign: TextAlign.center,
                    //         style:
                    //             Theme.of(context).textTheme.headline4!.copyWith(
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Theme.of(context)
                    //                       .colorScheme
                    //                       .onBackground,
                    //                 ),
                    //       ),
                    //       SizedBox(
                    //         width: kItemsSpacingSmallConstant,
                    //       ),
                    //       SvgPicture.asset(
                    //         "assets/icon/nodle.svg",
                    //         height: kIconSizeLargeConstant,
                    //       ),
                    //     ],
                    //   ),
                    //   message: nodleUsageMessage,
                    //   onTap: () {
                    //     Navigator.pushReplacementNamed(
                    //       context,
                    //       RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                    //     );
                    //   },
                    //   pageIndex: pageIndex,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
