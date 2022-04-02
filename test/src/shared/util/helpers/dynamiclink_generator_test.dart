import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/shared/util/helpers/dynamiclink_generator.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFirebaseDynamicLink extends Fake implements FirebaseDynamicLinks {
  @override
  Future<ShortDynamicLink> buildShortLink(DynamicLinkParameters parameters,
      {ShortDynamicLinkType shortLinkType = ShortDynamicLinkType.short}) async {
    // TODO: implement buildShortLink
    return ShortDynamicLink(
      type: ShortDynamicLinkType.short,
      shortUrl: Uri.parse('https://m.chaseapp.tv/bqWD'),
    );
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  F.appFlavor = Flavor.PROD;
  test('Generate Dynamic link', () async {
    //arrange
    final Chase chase = Chase(
      id: 'id',
      name: 'name',
      imageURL:
          'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chases%2F355f8bff-aee7-11ec-80ed-53b18af79ec0%2FScreen%20Shot%202022-03-28%20at%205.11.17%20PM.png?alt=media&token=355f8bff-aee7-11ec-80ed-53b18af79ec0',
      live: true,
      createdAt: DateTime.now(),
      desc: 'desc',
      votes: 100,
    );
    //act
    final String shortDynamicLink =
        await createChaseDynamicLink(chase, FakeFirebaseDynamicLink());
    //expect
    expect(shortDynamicLink, 'https://m.chaseapp.tv/bqWD');
  });
}
