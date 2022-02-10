enum SIGNINMETHOD {
  EMAILNPASSWORD,
  GOOGLE,
  APPLE,
  FACEBOOK,
  TWITTER,
}

extension SignInMethodIcon on SIGNINMETHOD {
  String get getAssetIcon {
    switch (this) {
      case SIGNINMETHOD.GOOGLE:
        return "assets/icon/google.svg";
        break;
      case SIGNINMETHOD.APPLE:
        return "assets/icon/apple.svg";

        break;
      case SIGNINMETHOD.FACEBOOK:
        return "assets/icon/facebook.svg";

        break;
      case SIGNINMETHOD.TWITTER:
        return "assets/icon/twitter.svg";

        break;
      default:
        throw UnimplementedError();
    }
  }
}
