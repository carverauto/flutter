// Development

// ignore_for_file: public_member_api_docs, avoid_classes_with_only_static_members

import 'dart:io';

import '../../flavors.dart';

class AppBundleInfo {
  static const String appstoreId = '1462719760';

  static const String devDynamicLinkHostUrl = 'https://carverauto.page.link';

  static const String devIosBundleId = 'com.carverauto.chaseapp.cdev';

  static const String devAndroidBundleId = 'com.carverauto.chasedev';

// Production

  static const String prodDynamicLinkHostUrl = 'https://m.chaseapp.tv';

  static const String prodAndroidBundleId = 'com.carverauto.chaseapp';

  static const String prodIosBundleId = 'com.carverauto.chaseapp';

  static String dynamicLinkHostUrl(bool forEmail) {
    final String url = F.appFlavor == Flavor.DEV
        ? devDynamicLinkHostUrl
        : prodDynamicLinkHostUrl;
    return forEmail ? '$url/' : url;
  }

  static String get dynamicLinkPrefix =>
      F.appFlavor == Flavor.DEV ? 'carverauto.com' : 'chaseapp.tv';

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

class EnvVaribales {
  static const String twitterToken = String.fromEnvironment('Twitter_Token');
  static const String youtubeApiKey = String.fromEnvironment('Youtbe_Api_Key');
  static const String youtubeToken = String.fromEnvironment('Youtube_Token');
  static const String devGetStreamChatApiKey =
      String.fromEnvironment('Dev_GetStream_Chat_Api_Key');
  static const String prodGetStreamChatApiKey =
      String.fromEnvironment('Prod_GetStream_Chat_Api_Key');
}
