// Development

// ignore_for_file: public_member_api_docs, avoid_classes_with_only_static_members

import 'dart:io';

import '../../flavors.dart';

class AppBundleInfo {
  static const String _appstoreId = '1462719760';
  static String get appstoreId => _appstoreId;

  static const String _devDynamicLinkHostUrl = 'https://carverauto.page.link';
  static String get devDynamicLinkHostUrl => _devDynamicLinkHostUrl;

  static const String _devIosBundleId = 'com.carverauto.chaseapp.cdev';
  static String get devIosBundleId => _devIosBundleId;

  static const String _devAndroidBundleId = 'com.carverauto.chasedev';
  static String get devAndroidBundleId => _devAndroidBundleId;

// Production

  static const String _prodDynamicLinkHostUrl = 'https://m.chaseapp.tv';
  static String get prodDynamicLinkHostUrl => _prodDynamicLinkHostUrl;

  static const String _prodAndroidBundleId = 'com.carverauto.chaseapp';
  static String get prodAndroidBundleId => _prodAndroidBundleId;

  static const String _prodIosBundleId = 'com.carverauto.chaseapp';
  static String get prodIosBundleId => _prodIosBundleId;

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
  static const String _twitterToken = String.fromEnvironment('Twitter_Token');
  static String get twitterToken => _twitterToken;
  static const String _twitterApiKey =
      String.fromEnvironment('Twitter_Api_key');
  static String get twitterApiKey => _twitterApiKey;
  static const String _twitterSecretKey =
      String.fromEnvironment('Twitter_Secret_key');
  static String get twitterSecretKey => _twitterSecretKey;
  static const String _youtubeApiKey = String.fromEnvironment('Youtbe_Api_Key');
  static String get youtubeApiKey => _youtubeApiKey;
  static const String _youtubeToken = String.fromEnvironment('Youtube_Token');
  static String get youtubeToken => _youtubeToken;
  static const String _getStreamChatApiKey =
      String.fromEnvironment('GetStream_Chat_Api_Key');
  static String get getStreamChatApiKey => _getStreamChatApiKey;
  // static const String _prodGetStreamChatApiKey =
  //     String.fromEnvironment('Prod_GetStream_Chat_Api_Key');
  // static String get prodGetStreamChatApiKey => _prodGetStreamChatApiKey;

  static const String instanceId = String.fromEnvironment('Pusher_Instance_Id');
}
