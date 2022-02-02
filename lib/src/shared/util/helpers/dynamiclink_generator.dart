import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createRecordDynamicLink(Chase chase) async {
  //Dynamic link generalization
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://carverauto.page.link',
    //alertroomid=${alertroomid}&
    link: Uri.parse('https://carverauto.com/chases?chaseId=${chase.id}'),
    iosParameters: IOSParameters(
      minimumVersion: '0',
      bundleId: 'com.carverauto.chaseapp.cdev',
    ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: chase.name,
      description: chase.desc,
      imageUrl: Uri.parse(chase.imageURL ?? defaultChaseImage),
    ),
    androidParameters: AndroidParameters(
      packageName: 'com.carverauto.chasedev',
      minimumVersion: 0,
    ),
  );

  final Uri shortDynamicLink =
      await FirebaseDynamicLinks.instance.buildLink(parameters);

  return shortDynamicLink.toString();
}
