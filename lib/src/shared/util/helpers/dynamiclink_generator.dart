import 'dart:developer';

import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createRecordDynamicLink(Chase chase) async {
  final fallbackUrl = Uri.parse("https://chaseapp.tv/chase/${chase.id}");

  final prodBundleId = "com.carverauto.chaseapp";

  final devAndroidBundleId = 'com.carverauto.chasedev';
  final devIosBundleId = 'com.carverauto.chaseapp.cdev';

  final uriPrefix = F.appFlavor == Flavor.DEV
      ? "https://carverauto.page.link"
      : "https://m.chaseapp.tv";
  log(uriPrefix);
  final linkPrefix =
      F.appFlavor == Flavor.DEV ? "carverauto.com" : "chaseapp.tv";

  final link = Uri.parse('https://$linkPrefix/chases?chaseId=${chase.id}');
  log(link.toString());
  //Dynamic link generalization
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: uriPrefix,
    link: link,
    androidParameters: AndroidParameters(
      packageName:
          F.appFlavor == Flavor.DEV ? devAndroidBundleId : prodBundleId,
      minimumVersion: 0,
      fallbackUrl: fallbackUrl,
    ),
    iosParameters: IOSParameters(
      minimumVersion: '0',
      bundleId: F.appFlavor == Flavor.DEV ? devIosBundleId : prodBundleId,
      fallbackUrl: fallbackUrl,
      appStoreId: "1462719760",
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: chase.name,
      description: chase.desc,
      imageUrl: Uri.parse(chase.imageURL ?? defaultChaseImage),
    ),
  );
  //TODO:Need to report
  //Proper link is not generated if creating for custom domains using .buildLink()?
  //This is serious issue.
  final ShortDynamicLink shortDynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  log(parameters.uriPrefix.toString());
  return shortDynamicLink.shortUrl.toString();
}
