import 'package:chaseapp/src/shared/enums/social_logins.dart';

extension SocialLoginIcon on SIGNINMETHOD {
  String getIconPath() {
    switch (this) {
      case SIGNINMETHOD.EMAILNPASSWORD:
        throw UnimplementedError();

      case SIGNINMETHOD.GOOGLE:
        return 'assets/icons/google.svg';

      case SIGNINMETHOD.APPLE:
        return 'assets/icons/apple.svg';

      default:
        throw UnimplementedError();
    }
  }
}
