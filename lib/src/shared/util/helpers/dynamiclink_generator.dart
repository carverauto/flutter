import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../../../const/app_bundle_info.dart';
import '../../../const/images.dart';
import '../../../models/chase/chase.dart';
import 'image_url_parser.dart';

Future<String> createChaseDynamicLink(Chase chase) async {
  final Uri fallbackUrl = Uri.parse('https://chaseapp.tv/chase/${chase.id}');
  final String shareImage = chase.imageURL != null || chase.imageURL!.isNotEmpty
      ? parseImageUrl(chase.imageURL!)
      : defaultPhotoURL;

  final String uriPrefix = AppBundleInfo.dynamicLinkHostUrl(false);

  final String linkPrefix = AppBundleInfo.dynamicLinkPrefix;

  final Uri link = Uri.parse('https://$linkPrefix/chases?chaseId=${chase.id}');
  //Dynamic link generalization
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: uriPrefix,
    link: link,
    androidParameters: AndroidParameters(
      packageName: AppBundleInfo.androidBundleId,
      minimumVersion: 0,
      fallbackUrl: fallbackUrl,
    ),
    iosParameters: IOSParameters(
      minimumVersion: '0',
      bundleId: AppBundleInfo.iosBundleId,
      fallbackUrl: fallbackUrl,
      appStoreId: AppBundleInfo.appstoreId,
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: chase.name,
      description: chase.desc,
      imageUrl: Uri.parse(shareImage),
    ),
  );
  //TODO:Need to report
  //Proper link is not generated if creating for custom domains using .buildLink()?
  //This is serious issue.
  log('message');
  final ShortDynamicLink shortDynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  log(parameters.uriPrefix.toString());
  return shortDynamicLink.shortUrl.toString();
}
