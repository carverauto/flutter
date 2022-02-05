import 'package:chaseapp/src/shared/enums/social_logins.dart';

SIGNINMETHOD getSignInProviderHelper(String unKnownProvider) {
  switch (unKnownProvider) {
    case "apple.com":
      return SIGNINMETHOD.APPLE;

    case "google.com":
      return SIGNINMETHOD.GOOGLE;

    case "facebook.com":
      return SIGNINMETHOD.FACEBOOK;

    case "twitter.com":
      return SIGNINMETHOD.TWITTER;

    default:
      throw Exception("Unknown provider: $unKnownProvider");
  }
}
