import 'package:flutter/material.dart';

import '../../../const/images.dart';

class ChaseAppNameLogoImage extends StatelessWidget {
  const ChaseAppNameLogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      chaseAppNameImage,
      color: Colors.white,
      cacheHeight: 60,
      cacheWidth: 478,
    );
  }
}

class ChaseAppLogoImage extends StatelessWidget {
  const ChaseAppLogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        chaseAppLogoAssetImage,
        height: 64,
        width: 64,
      ),
    );
  }
}
