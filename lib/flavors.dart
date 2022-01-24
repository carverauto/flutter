enum Flavor {
  PROD,
  DEV,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.PROD:
        return 'Coves Management';
      case Flavor.DEV:
        return 'Coves Management Dev';
      default:
        return 'title';
    }
  }

}
