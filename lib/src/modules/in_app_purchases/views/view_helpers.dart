import 'package:flutter/material.dart';

import '../../../const/sizings.dart';
import '../../../shared/shaders/animating_gradient/animating_gradient_shader_view.dart';
import '../../../shared/widgets/buttons/glass_button.dart';
import 'in_app_purchases_view.dart';

Future<void> showInAppPurchasesDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const _PremiumContentView();
    },
  );
}

Future<void> showInAppPurchasesBottomSheet(BuildContext context) async {
  showBottomSheet<void>(
    context: context,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kBorderRadiusMediumConstant),
        topRight: Radius.circular(kBorderRadiusMediumConstant),
      ),
    ),
    clipBehavior: Clip.hardEdge,
    builder: (BuildContext context) {
      return const _PremiumContentView();
    },
  );
}

class _PremiumContentView extends StatelessWidget {
  const _PremiumContentView();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: kPaddingMediumConstant),
              AnimatingGradientShaderBuilder(
                child: Text(
                  'Get ChaseApp Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: InAppPurchasesMainView()),
            ],
          ),
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const SizedBox(
                  height: 5,
                  width: 150,
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: kPaddingMediumConstant,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const GlassBg(child: Icon(Icons.close)),
            ),
          ),
        ],
      ),
    );
  }
}
