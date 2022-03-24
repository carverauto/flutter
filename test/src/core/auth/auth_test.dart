import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

//TODO:Auth better be tested with Integration testing as native calls
// are required for facebook,twitter logins
void main() {
  final MockGoogleSignIn googleSignIn = MockGoogleSignIn();
  final FakeFirebaseFirestore fakeFirestore = FakeFirebaseFirestore();

  TestWidgetsFlutterBinding.ensureInitialized();
  test('Test Google Auth Sign In', () async {
    final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication signInAuthentication =
        await signInAccount!.authentication;
    expect(signInAuthentication, isNotNull);
    expect(googleSignIn.currentUser, isNotNull);
    expect(signInAuthentication.accessToken, isNotNull);
    expect(signInAuthentication.idToken, isNotNull);

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: signInAuthentication.accessToken,
      idToken: signInAuthentication.idToken,
    );
    // Sign in.
    final MockUser mockUser = MockUser(
      uid: 'uid',
      email: 'takrutvik@gmail.com',
      displayName: 'Rutvik Tak',
    );
    final MockFirebaseAuth auth = MockFirebaseAuth(mockUser: mockUser);
    final UserCredential result = await auth.signInWithCredential(credential);
    final User? user = result.user;
    await fakeFirestore.collection('users').doc(user!.uid).set(
          UserData(
            uid: user.uid,
            email: user.uid,
            lastUpdated: DateTime.now().millisecondsSinceEpoch,
          ).toJson(),
        );
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await fakeFirestore.collection('users').doc('uid').get();

    final UserData userData = UserData.fromJson(userDoc.data()!);

    print(userData.toJson());
  });

  test(
    'should return null when google login is cancelled by the user',
    () async {
      googleSignIn.setIsCancelled(true);
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
    },
  );

  test(
    'testing google login twice, once cancelled, once not cancelled at the same test.',
    () async {
      googleSignIn.setIsCancelled(true);
      final GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
      googleSignIn.setIsCancelled(false);
      final GoogleSignInAccount? signInAccountSecondAttempt =
          await googleSignIn.signIn();
      expect(signInAccountSecondAttempt, isNotNull);
    },
  );
}
