// Development

import 'dart:io';

import 'package:chaseapp/flavors.dart';

class AppBundleInfo {
  static const appstoreId = "1462719760";

  static const devDynamicLinkHostUrl = "https://carverauto.page.link/";

  static const devIosBundleId = 'com.carverauto.chaseapp.cdev';

  static const devAndroidBundleId = "com.carverauto.chasedev";

// Production

  static const prodDynamicLinkHostUrl = "https://m.chaseapp.tv/";

  static const prodAndroidBundleId = 'com.carverauto.chaseapp';

  static const prodIosBundleId = "com.carverauto.chaseapp";

  static String get dynamicLinkHostUrl => F.appFlavor == Flavor.DEV
      ? devDynamicLinkHostUrl
      : prodDynamicLinkHostUrl;
  static String get dynamicLinkPrefix =>
      F.appFlavor == Flavor.DEV ? "carverauto.com" : "chaseapp.tv";

  static String get bundleId {
    if (F.appFlavor == Flavor.DEV) {
      if (Platform.isAndroid) {
        return devAndroidBundleId;
      } else {
        return devIosBundleId;
      }
    } else {
      if (Platform.isAndroid) {
        return prodAndroidBundleId;
      } else {
        return prodIosBundleId;
      }
    }
  }

  static String get androidBundleId {
    if (F.appFlavor == Flavor.DEV) {
      return devAndroidBundleId;
    } else {
      return prodAndroidBundleId;
    }
  }

  static String get iosBundleId {
    if (F.appFlavor == Flavor.DEV) {
      return devIosBundleId;
    } else {
      return prodIosBundleId;
    }
  }
}
