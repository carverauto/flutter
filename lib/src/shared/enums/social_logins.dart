enum SIGNINMETHOD {
  Google,
  Apple,
  Facebook,
  Twitter,
  Email,
}

extension SignInMethodIcon on SIGNINMETHOD {
  String get getAssetIcon {
    switch (this) {
      case SIGNINMETHOD.Google:
        return 'assets/icon/google.svg';

      case SIGNINMETHOD.Apple:
        return 'assets/icon/apple.svg';

      case SIGNINMETHOD.Facebook:
        return 'assets/icon/facebook.svg';

      case SIGNINMETHOD.Twitter:
        return 'assets/icon/twitter.svg';
      case SIGNINMETHOD.Email:
        return 'assets/icon/email.svg';
    }
  }
}

SIGNINMETHOD getSignInProviderHelper(String unKnownProvider) {
  switch (unKnownProvider) {
    case 'apple.com':
      return SIGNINMETHOD.Apple;

    case 'google.com':
      return SIGNINMETHOD.Google;

    case 'facebook.com':
      return SIGNINMETHOD.Facebook;

    case 'twitter.com':
      return SIGNINMETHOD.Twitter;
    case 'emailLink':
      return SIGNINMETHOD.Email;

    default:
      throw Exception('Unknown provider: $unKnownProvider');
  }
}
