import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/routeNames.dart';
import '../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../shared/styles.dart';
import '../../../shared/widgets/brand/chaseapp_brand_widgets.dart';
import '../../../shared/widgets/buttons/glass_button.dart';
import '../app_review_notifier.dart';

class LikedTheAppDialog extends ConsumerStatefulWidget {
  const LikedTheAppDialog({super.key});

  @override
  ConsumerState<LikedTheAppDialog> createState() => _LikedTheAppDialogState();
}

class _LikedTheAppDialogState extends ConsumerState<LikedTheAppDialog> {
  bool? isLoved;
  bool isDoNotAskAgain = false;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, double animation, Widget? child) {
        return Transform.translate(
          offset: Offset(0, -100 * (1 - animation)),
          child: Opacity(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Dialog(
        child: Stack(
          children: [
            const Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Corners.medRadius),
                child: AnimatingGradientShaderBuilder(
                  child: ColoredBox(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GlassBg(
              color: Colors.black54,
              child: Padding(
                padding: EdgeInsets.all(Insets.med),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ChaseAppLogoImage(),
                    SizedBox(
                      height: Insets.sm,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: isLoved != null
                          ? isLoved!
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Would you like to rate us?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        5,
                                        (int index) => const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    'We are really sorry to hear that.\nWould you like to tell us why?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .fontSize,
                                    ),
                                  ),
                                )
                          : Center(
                              child: Text(
                                'Loving ChaseApp? 🤩',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: Insets.sm,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: isLoved != null
                          ? isLoved!
                              ? ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(
                                              appReviewStateNotifier.notifier,
                                            )
                                            .resetCount();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Remind Later',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text(
                                        'Absolutely!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).popAndPushNamed(
                                        RouteName.BUG_REPORT,
                                      );
                                    },
                                    child: const Text(
                                      'Tell us',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                          : Column(
                              children: [
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        isLoved = false;
                                        await ref
                                            .read(
                                              appReviewStateNotifier.notifier,
                                            )
                                            .resetCount();
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Not really',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Insets.sm,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        isLoved = true;
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Loving it!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(appReviewStateNotifier.notifier)
                                        .resetCount();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Remind Later',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Insets.sm,
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isDoNotAskAgain,
                                      onChanged: (bool? value) {
                                        ref
                                            .read(
                                              appReviewStateNotifier.notifier,
                                            )
                                            .updateDoNotAskAgain(
                                              value ?? false,
                                            );

                                        setState(() {
                                          isDoNotAskAgain = value!;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Do not ask again.',
                                      style: TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
