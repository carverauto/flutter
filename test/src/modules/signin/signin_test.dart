import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultiAuth SignIn Providers Enum Getter From String', () {
    test('apple.com', () {
      final SIGNINMETHOD signInProvider = getSignInProviderHelper('apple.com');
      expect(signInProvider, SIGNINMETHOD.Apple);
    });
    test('google.com', () {
      final SIGNINMETHOD signInProvider = getSignInProviderHelper('google.com');
      expect(signInProvider, SIGNINMETHOD.Google);
    });
    test('facebook.com', () {
      final SIGNINMETHOD signInProvider =
          getSignInProviderHelper('facebook.com');
      expect(signInProvider, SIGNINMETHOD.Facebook);
    });
    test('twitter.com', () {
      final SIGNINMETHOD signInProvider =
          getSignInProviderHelper('twitter.com');
      expect(signInProvider, SIGNINMETHOD.Twitter);
    });
    test('emailLink', () {
      final SIGNINMETHOD signInProvider = getSignInProviderHelper('emailLink');
      expect(signInProvider, SIGNINMETHOD.Email);
    });
    test('Unkown Provider', () {
      expect(
        getSignInProviderHelper('Unkown Provider'),
        SIGNINMETHOD.Unknown,
      );
    });
  });
}
