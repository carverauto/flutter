import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../const/sizings.dart';
import '../../../core/top_level_providers/services_providers.dart';
import '../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';

final FutureProvider<purchases.Offerings> currentOfferingFutureProvider =
    FutureProvider<purchases.Offerings>(
  (FutureProviderRef<purchases.Offerings> ref) async {
    final purchases.Offerings offerings =
        await purchases.Purchases.getOfferings();

    return offerings;
  },
);

final AutoDisposeFutureProvider<purchases.CustomerInfo> currentCustomerInfo =
    FutureProvider.autoDispose<purchases.CustomerInfo>(
  (AutoDisposeFutureProviderRef<purchases.CustomerInfo> ref) async {
    final purchases.CustomerInfo custemerInfo =
        await purchases.Purchases.getCustomerInfo();

    return custemerInfo;
  },
);

class InAppPurchasesView extends ConsumerStatefulWidget {
  const InAppPurchasesView({super.key});

  @override
  ConsumerState<InAppPurchasesView> createState() => _InAppPurchasesViewState();
}

class _InAppPurchasesViewState extends ConsumerState<InAppPurchasesView>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  bool isShowingMonthly = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isPremiumMember =
        ref.watch(inAppPurchasesStateNotifier.notifier).isPremiumMember;

    final AsyncValue<purchases.Offerings> offeringsState =
        ref.watch(currentOfferingFutureProvider);

    return offeringsState.when(
      data: (purchases.Offerings offerings) {
        final purchases.Package? yearlyPricing = offerings.current?.annual;
        final purchases.Package? monthlyPricing = offerings.current?.monthly;
        // calculate discount from month to yearp pricing

        final double perMonthYearlyPrice =
            (yearlyPricing?.storeProduct.price ?? 0) / 12;

        final int discount =
            (((monthlyPricing!.storeProduct.price - perMonthYearlyPrice).abs() /
                        (monthlyPricing.storeProduct.price)) *
                    100)
                .round();
        if (isPremiumMember) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('You are a premium member'),
                  // add cancel subs button and refund button

                  ElevatedButton(
                    onPressed: () async {
                      final String? managementUrl = ref
                          .read(inAppPurchasesStateNotifier.notifier)
                          .state
                          .value
                          ?.managementURL;
                      if (managementUrl != null) {
                        await launchURL(context, managementUrl);
                        await ref
                            .read(inAppPurchasesStateNotifier.notifier)
                            .updateCustomerInfo();
                      }
                    },
                    child: const Text('Cancel Subscription'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await purchases.Purchases.restorePurchases();
                    },
                    child: const Text('Restore Purchases'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('ChaseApp Premium✨ '),
            centerTitle: false,
          ),
          body: ListView(
            children: [
              const SizedBox(
                height: kPaddingLargeConstant,
              ),
              Center(
                child: SizedBox(
                  width: 270,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          clipBehavior: Clip.hardEdge,
                          child: Banner(
                            message: 'Save $discount%',
                            location: BannerLocation.topEnd,
                            color:
                                isShowingMonthly ? Colors.grey : Colors.green,
                            layoutDirection: TextDirection.ltr,
                            child: TabBar(
                              padding: const EdgeInsets.all(0),
                              controller: tabController,
                              onTap: (int value) {
                                isShowingMonthly = value == 0;
                                setState(() {});
                              },
                              unselectedLabelColor: Colors.grey,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              indicator: BoxDecoration(
                                color: Colors.purple,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                              ),
                              labelPadding:
                                  const EdgeInsets.all(kPaddingSmallConstant)
                                      .copyWith(
                                bottom: kPaddingSmallConstant + 10,
                                top: kPaddingSmallConstant + 10,
                              ),
                              tabs: const [
                                Text('Monthly'),
                                Text('Yearly'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    SizedBox.shrink(),
                    SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(
                height: kPaddingSmallConstant,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 300,
                    maxWidth: 600,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: OfferingsDescription(
                      availablePackages: offerings.current!.availablePackages,
                      isShowingMonthly: isShowingMonthly,
                      discount: discount,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (Object error, StackTrace? stackTrace) {
        return Container(
          child: Text(error.toString()),
        );
      },
    );
  }
}

class OfferingsDescription extends StatefulWidget {
  const OfferingsDescription({
    super.key,
    required this.availablePackages,
    required this.isShowingMonthly,
    required this.discount,
  });

  final List<purchases.Package> availablePackages;

  final bool isShowingMonthly;
  final int discount;

  @override
  State<OfferingsDescription> createState() => _OfferingsDescriptionState();
}

class _OfferingsDescriptionState extends State<OfferingsDescription>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<double> animation;
  bool isShowingMonthly = true;

  late purchases.Package package;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    package = widget.availablePackages.firstWhereOrNull(
      (purchases.Package package) =>
          package.packageType ==
          (widget.isShowingMonthly
              ? purchases.PackageType.monthly
              : purchases.PackageType.annual),
    )!;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation = Tween<double>(begin: 0, end: package.storeProduct.price ?? 0)
        .animate(animationController);
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant OfferingsDescription oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isShowingMonthly != widget.isShowingMonthly) {
      package = widget.availablePackages.firstWhereOrNull(
        (purchases.Package package) =>
            package.packageType ==
            (widget.isShowingMonthly
                ? purchases.PackageType.monthly
                : purchases.PackageType.annual),
      )!;
      final purchases.Package? oldPackage =
          widget.availablePackages.firstWhereOrNull(
        (purchases.Package package) =>
            package.packageType ==
            (oldWidget.isShowingMonthly
                ? purchases.PackageType.monthly
                : purchases.PackageType.annual),
      );

      if (package != null) {
        animation = Tween<double>(
          begin: oldPackage?.storeProduct.price ?? 0,
          end: package.storeProduct.price ?? 0,
        ).animate(animationController);
        animationController
          ..reset()
          ..forward();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${package.storeProduct.currencyCode ?? ''} ${animation.value.toInt()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize:
                        Theme.of(context).textTheme.headlineLarge!.fontSize,
                  ),
                ),

                //show monthly yearly string
                Text(
                  widget.isShowingMonthly ? '/ Month' : '/ Year',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: kPaddingSmallConstant,
        ),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: child,
                ),
              );
            },
            child: widget.isShowingMonthly
                ? null
                : Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[100],
                        borderRadius: BorderRadius.circular(
                          kBorderRadiusLargeConstant,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kPaddingSmallConstant),
                        child: Text(
                          ' (Save ${widget.discount}%) for 12 months at ${package.storeProduct.currencyCode} ${((package.storeProduct.price) / 12).round()}/month',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: kPaddingSmallConstant,
        ),
        if (package != null)
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.purple[400],
              borderRadius: BorderRadius.circular(kBorderRadiusSmallConstant),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 250,
                maxHeight: 400,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ListView.builder(
                              itemCount: premiumFeatures.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: kPaddingSmallConstant,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: kPaddingXSmallConstant,
                                  ),
                                  child: premiumFeatures[index],
                                );
                              },
                            ),
                          ),
                          const Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      kBorderRadiusSmallConstant,
                                    ),
                                  ),
                                  boxShadow: [],
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.white38,
                                    ],
                                    stops: [
                                      0.001,
                                      0.5,
                                      1.0,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(
          height: kPaddingMediumConstant,
        ),
        Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    kBorderRadiusSmallConstant,
                  ),
                  child: AnimatingGradientShaderBuilder(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          kBorderRadiusSmallConstant,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    kBorderRadiusSmallConstant,
                  ),
                ),
                backgroundColor:
                    Theme.of(context).colorScheme.background.withOpacity(
                          0.3,
                        ),
              ),
              onPressed: () async {
                try {
                  final purchases.CustomerInfo purchaserInfo =
                      await purchases.Purchases.purchasePackage(
                    package,
                  );
                } on PlatformException catch (e) {
                  if (e.code != 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message.toString()),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: Text(
                'Subscribe',
                style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PremiumFeatureTile extends StatelessWidget {
  const PremiumFeatureTile({
    super.key,
    required this.description,
    required this.leading,
    required this.title,
  });

  final Widget leading;
  final String description;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPaddingXSmallConstant / 2),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kPaddingXSmallConstant),
                  child: leading,
                ),
              ),
              const SizedBox(
                width: kPaddingXSmallConstant,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: kPaddingXSmallConstant,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

List<PremiumFeatureTile> premiumFeatures = [
  const PremiumFeatureTile(
    title: 'Firehose',
    leading: Text('🔥', style: TextStyle(fontSize: 24)),
    description:
        'Get real-time notifications from our curated twitter feed, also includes alerts for major earthquakes, severe weather, and more.',
  ),
  const PremiumFeatureTile(
    title: 'Airport Inventory',
    leading: Icon(Icons.airport_shuttle),
    description:
        'Get notified when a media airship arrives or leaves an airport.',
  ),
  const PremiumFeatureTile(
    title: 'Cluster Alerts',
    leading: Icon(Icons.flight),
    description:
        'Receive a notification when media and law enforcement aircraft find themselves in the same airspace.',
  ),
  const PremiumFeatureTile(
    title: 'Flight Time Estimation',
    leading: Icon(Icons.map),
    description:
        'Use our map tools to determine how far away a helicopter is from a given point. Useful to see when media might arrive on-scene.',
  ),
  const PremiumFeatureTile(
    title: 'Helicopter Tracks',
    leading: Icon(Icons.chat_outlined),
    description: 'Show helicopter flight paths on the map.',
  ),
  const PremiumFeatureTile(
    title: 'StormSurge Notifications',
    leading: Icon(Icons.wb_cloudy),
    description:
        'Get an alert when a major coastal storm surge event is happening. Useful to show and get notified about rising water levels before/during a storm.',
  ),
  const PremiumFeatureTile(
    title: 'Community Lounge',
    leading: Icon(Icons.chat),
    description:
        'A dedicated chat and lounge area for premium users, available 24/7.',
  ),
  const PremiumFeatureTile(
    title: 'Discord Integration',
    leading: Icon(Icons.discord),
    description: 'Get notifications in your Discord server.',
  ),
  const PremiumFeatureTile(
    title: 'Slack Integration',
    leading: Icon(Icons.message),
    description: 'Get notifications in your Slack server.',
  ),
  const PremiumFeatureTile(
    title: 'Rocket Launches',
    leading: Icon(Icons.rocket),
    description:
        'Get notifications when a rocket launch is happening, with live video.',
  ),
];
