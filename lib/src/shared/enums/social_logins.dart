enum SIGNINMETHOD {
  EMAILNPASSWORD,
  Google,
  Apple,
  Facebook,
  Twitter,
}

extension SignInMethodIcon on SIGNINMETHOD {
  String get getAssetIcon {
    switch (this) {
      case SIGNINMETHOD.Google:
        return "assets/icon/google.svg";
        break;
      case SIGNINMETHOD.Apple:
        return "assets/icon/apple.svg";

        break;
      case SIGNINMETHOD.Facebook:
        return "assets/icon/facebook.svg";

        break;
      case SIGNINMETHOD.Twitter:
        return "assets/icon/twitter.svg";

        break;
      default:
        throw UnimplementedError();
    }
  }
}
