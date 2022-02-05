enum Flavor {
  PROD,
  DEV,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'ChaseApp Prod';
      case Flavor.DEV:
        return 'ChaseApp Dev';
      default:
        throw UnimplementedError();
    }
  }
}
