import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../const/sizings.dart';
import '../../../core/top_level_providers/services_providers.dart';
import '../../../device_info.dart';
import '../../../routes/routeNames.dart';
import '../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../shared/shaders/confetti/confetti_shader_view.dart';
import '../../../shared/widgets/buttons/glass_button.dart';
import '../../../shared/widgets/loaders/loading.dart';

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
  @override
  Widget build(
    BuildContext context,
  ) {
    final AsyncValue<purchases.CustomerInfo> info =
        ref.watch(inAppPurchasesStateNotifier);

    final bool isPremium =
        info.value?.entitlements.all['Premium']?.isActive ?? false;

    final AsyncValue<purchases.Offerings> offeringsState =
        ref.watch(currentOfferingFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChaseApp Premium✨'),
        centerTitle: false,
        backgroundColor: isPremium ? Colors.black : null,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return InAppPurchasesInfoDialog(ref: ref);
                },
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: offeringsState.when(
        data: (purchases.Offerings offerings) {
          if (isPremium) {
            final List<String> memeberSince =
                info.value!.allPurchaseDates.values
                    .sortedByCompare<String>(
                      (String element) => element,
                      (String a, String b) => DateTime.parse(b).millisecond <
                              DateTime.parse(a).millisecond
                          ? 1
                          : -1,
                    )
                    .toList();
            final DateTime memberSince = DateTime.parse(memeberSince.first);
            final DateTime latestSubscriptionDate =
                DateTime.parse(memeberSince.last);
            final DateTime renewsAt =
                DateTime.parse(info.value!.latestExpirationDate!);

            return Stack(
              children: [
                const Positioned.fill(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: ConfettiShaderView(
                      child: ColoredBox(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GlassBg(
                    color: Colors.white10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AnimatingGradientShaderBuilder(
                              child: Text(
                                '🌟 You are a ChaseApp Premium Member',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: kPaddingXSmallConstant,
                            ),
                            const PremiumFeaturesDisplayView(),
                            const SizedBox(
                              height: kPaddingXSmallConstant,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Member since  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // format date in dd mm yyyy
                                  DateFormat('dd MMM yyyy').format(memberSince),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: kPaddingXSmallConstant,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Latest subscription date  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // format date in dd mm yyyy
                                  DateFormat('dd MMM yyyy')
                                      .format(latestSubscriptionDate),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Renews at  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  // format date in dd mm yyyy
                                  DateFormat('dd MMM yyyy').format(renewsAt),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kPaddingSmallConstant,
                        ),
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
                          child: const Text('Manage Subscription'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return PurchasePremiumSubscriptionView(
            offerings: offerings,
          );
        },
        loading: () => const Center(
          child: CircularAdaptiveProgressIndicatorWithBg(),
        ),
        error: (Object error, StackTrace? stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
      ),
    );
  }
}

class InAppPurchasesInfoDialog extends StatelessWidget {
  const InAppPurchasesInfoDialog({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          const Icon(Icons.info),
          const SizedBox(
            width: kPaddingXSmallConstant,
          ),
          Text(
            'Support',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Checking to restore any purchases made in past.',
                      ),
                    ),
                  );
                  final purchases.CustomerInfo customerInfo =
                      await purchases.Purchases.restorePurchases();

                  await ref
                      .read(inAppPurchasesStateNotifier.notifier)
                      .updateCustomerInfo(customerInfo);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Details updated.',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Something went wrong. Please try again.',
                      ),
                    ),
                  );
                }
              },
              leading: Icon(
                Icons.restore,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Restore Previous Purchases',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "Restore any purchases you've made in the past which are active.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                await Navigator.of(context).pushNamed(RouteName.SUPPORT);
              },
              leading: Icon(
                Icons.support_agent_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Get In Touch',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PurchasePremiumSubscriptionView extends ConsumerStatefulWidget {
  const PurchasePremiumSubscriptionView({
    super.key,
    required this.offerings,
  });

  final purchases.Offerings offerings;

  @override
  ConsumerState<PurchasePremiumSubscriptionView> createState() =>
      _PurchasePremiumSubscriptionViewState();
}

class _PurchasePremiumSubscriptionViewState
    extends ConsumerState<PurchasePremiumSubscriptionView>
    with SingleTickerProviderStateMixin {
  bool isShowingMonthly = true;

  bool isMakingPurchase = false;

  late final TabController tabController;

  late purchases.Package? package;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    package = widget.offerings.current!.availablePackages.firstWhereOrNull(
      (purchases.Package package) =>
          package.packageType ==
          (isShowingMonthly
              ? purchases.PackageType.monthly
              : purchases.PackageType.annual),
    )!;
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> makePurchase() async {
    isMakingPurchase = true;
    try {
      setState(() {});
      final purchases.CustomerInfo purchaserInfo =
          await purchases.Purchases.purchasePackage(
        package!,
      );

      if (mounted) {
        await ref
            .read(
              inAppPurchasesStateNotifier.notifier,
            )
            .updateCustomerInfo(purchaserInfo);
      }
    } on PlatformException catch (e) {
      if (purchases.PurchasesErrorHelper.getErrorCode(
            e,
          ) !=
          purchases.PurchasesErrorCode.purchaseCancelledError) {
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
    } finally {
      if (mounted) {
        setState(() {
          isMakingPurchase = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant PurchasePremiumSubscriptionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    package = widget.offerings.current!.availablePackages.firstWhereOrNull(
      (purchases.Package package) =>
          package.packageType ==
          (isShowingMonthly
              ? purchases.PackageType.monthly
              : purchases.PackageType.annual),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offerings.current == null) {
      return const Center(
        child: Text('No Offerings Found'),
      );
    }

    final purchases.Package? yearlyPricing = widget.offerings.current!.annual;
    final purchases.Package? monthlyPricing = widget.offerings.current!.monthly;

    if (yearlyPricing == null || monthlyPricing == null) {
      return const Center(
        child: Text('No Monthly /Yearly Packages Available'),
      );
    }

    if (package == null) {
      return const Center(
        child: Text('No Package Available'),
      );
    }
    // calculate discount from month to yearp pricing

    final double perMonthYearlyPrice = (yearlyPricing.storeProduct.price) / 12;

    final int discount =
        (((monthlyPricing.storeProduct.price - perMonthYearlyPrice).abs() /
                    (monthlyPricing.storeProduct.price)) *
                100)
            .round();

    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
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
                          color: isShowingMonthly ? Colors.grey : Colors.green,
                          child: TabBar(
                            padding: const EdgeInsets.all(0),
                            controller: tabController,
                            onTap: (int value) {
                              isShowingMonthly = value == 0;
                              package = widget
                                  .offerings.current?.availablePackages
                                  .firstWhereOrNull(
                                (purchases.Package package) =>
                                    package.packageType ==
                                    (isShowingMonthly
                                        ? purchases.PackageType.monthly
                                        : purchases.PackageType.annual),
                              )!;

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
                    package: package!,
                    isShowingMonthly: isShowingMonthly,
                    discount: discount,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kPaddingSmallConstant,
            )
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Material(
            child: InkWell(
              onTap: makePurchase,
              child: AnimatedContainer(
                width: isMakingPurchase ? 48 : 150,
                clipBehavior: Clip.hardEdge,
                duration: const Duration(milliseconds: 300),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(
                  //   isMakingPurchase ? 150 : kBorderRadiusSmallConstant,
                  // ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned.fill(
                      child: AnimatingGradientShaderBuilder(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GlassBg(
                      child: Padding(
                        padding: const EdgeInsets.all(4).copyWith(
                          bottom: MediaQuery.of(context).viewPadding.bottom,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                          ) {
                            return SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.horizontal,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Center(
                            child: isMakingPurchase
                                ? Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )
                                    : const CircularProgressIndicator()
                                : Text(
                                    'Subscribe',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OfferingsDescription extends ConsumerStatefulWidget {
  const OfferingsDescription({
    super.key,
    required this.isShowingMonthly,
    required this.discount,
    required this.package,
  });

  final purchases.Package package;

  final bool isShowingMonthly;
  final int discount;

  @override
  ConsumerState<OfferingsDescription> createState() =>
      _OfferingsDescriptionState();
}

class _OfferingsDescriptionState extends ConsumerState<OfferingsDescription>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animation =
        Tween<double>(begin: 0, end: widget.package.storeProduct.price ?? 0)
            .animate(animationController);
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant OfferingsDescription oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.package.packageType != widget.package.packageType) {
      animation = Tween<double>(
        begin: oldWidget.package.storeProduct.price,
        end: widget.package.storeProduct.price,
      ).animate(animationController);
      animationController
        ..reset()
        ..forward();
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
    final purchases.Package package = widget.package;

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
                  '${package.storeProduct.currencyCode} ${animation.value.toInt()}',
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
        if (package != null) const PremiumFeaturesDisplayView(),
      ],
    );
  }
}

class PremiumFeaturesDisplayView extends StatelessWidget {
  const PremiumFeaturesDisplayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                      child: GridView.count(
                        //  itemCount: premiumFeatures.length,
                        crossAxisCount: DeviceScreen.get(context).gridCount,
                        padding: const EdgeInsets.symmetric(
                          vertical: kPaddingSmallConstant,
                        ),

                        mainAxisSpacing: kPaddingXSmallConstant,
                        //   crossAxisSpacing: kPaddingXSmallConstant,

                        children: premiumFeatures
                            .map(
                              (PremiumFeatureTile e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: kPaddingXSmallConstant,
                                  horizontal: kPaddingXSmallConstant,
                                ),
                                child: e,
                              ),
                            )
                            .toList(),
                        // itemBuilder: (BuildContext context, int index) {
                        //   return ;
                        // },
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.purple[300],
        borderRadius: BorderRadius.circular(kBorderRadiusStandard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingXSmallConstant),
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
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kPaddingXSmallConstant,
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
