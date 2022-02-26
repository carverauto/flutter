import 'package:chaseapp/src/shared/enums/social_logins.dart';

SIGNINMETHOD getSignInProviderHelper(String unKnownProvider) {
  switch (unKnownProvider) {
    case "apple.com":
      return SIGNINMETHOD.Apple;

    case "google.com":
      return SIGNINMETHOD.Google;

    case "facebook.com":
      return SIGNINMETHOD.Facebook;

    case "twitter.com":
      return SIGNINMETHOD.Twitter;

    default:
      throw Exception("Unknown provider: $unKnownProvider");
  }
}
