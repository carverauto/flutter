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

  final link = Uri.parse('https://carverauto.com/chases?chaseId=${chase.id}');

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
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: chase.name,
      description: chase.desc,
      imageUrl: Uri.parse(chase.imageURL ?? defaultChaseImage),
    ),
  );

  final Uri shortDynamicLink =
      await FirebaseDynamicLinks.instance.buildLink(parameters);

  return shortDynamicLink.toString();
}
