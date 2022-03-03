import 'dart:developer';

import 'package:chaseapp/src/const/app_bundle_info.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createChaseDynamicLink(Chase chase) async {
  final fallbackUrl = Uri.parse("https://chaseapp.tv/chase/${chase.id}");
  final shareImage = chase.imageURL != null || chase.imageURL!.isNotEmpty
      ? parseImageUrl(chase.imageURL!, ImageDimensions.MEDIUM)
      : defaultPhotoURL;

  final uriPrefix = AppBundleInfo.dynamicLinkHostUrl(false);

  final linkPrefix = AppBundleInfo.dynamicLinkPrefix;

  final link = Uri.parse('https://$linkPrefix/chases?chaseId=${chase.id}');
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
