import 'package:flutter/material.dart';

import '../../../const/sizings.dart';
import '../../../shared/widgets/buttons/glass_button.dart';
import 'in_app_purchases_view.dart';

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
      return Stack(
        children: [
          const InAppPurchasesMainView(),
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
      );
    },
  );
}
