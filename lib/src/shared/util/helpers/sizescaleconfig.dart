class Sizescaleconfig {
  static final double refrenceheight = 715.0;
  static final double referencewidth = 320.0;
  static double? screenheight;
  static double? screenwidth;
  static late double heightscaleratio;
  static late double widthscaleratio;
  static late double textscalefactor;

  static final extraSmallMobileBreakpoint = 380;
  static final mobileBreakpoint = 480;
  static final tabletBreakpoint = 900;

  static DeviceType get getDeviceType {
    if (screenwidth! <= extraSmallMobileBreakpoint) {
      return DeviceType.SMALL_MOBILE;
    } else if (screenwidth! <= mobileBreakpoint) {
      return DeviceType.MOBILE;
    } else if (screenwidth! > mobileBreakpoint &&
        screenwidth! <= tabletBreakpoint) {
      return DeviceType.TABLET;
    } else {
      return DeviceType.DESKTOP;
    }
  }

  static void calculaterscaleratio() {
    heightscaleratio = screenheight! / refrenceheight;
    widthscaleratio = screenwidth! / referencewidth;
  }

  static double scalehightfactor(double actualheight) {
    return actualheight * heightscaleratio;
  }

  static double scalewidthfactor(double actualwidth) {
    return actualwidth * widthscaleratio;
  }

  static double scaletextfactor(double actualfontsize) {
    return actualfontsize * heightscaleratio * textscalefactor;
  }

  static double scaleWidthFactorWithMaxMinConstraints(
      double actualWidth, double maxWidth, double minWidth) {
    final calculatedWidth = actualWidth * widthscaleratio;
    return calculatedWidth > maxWidth
        ? maxWidth
        : calculatedWidth < minWidth
            ? minWidth
            : calculatedWidth;
  }

  static double scaleHeightFactorWithMaxMinConstraints(
      double actualHeight, double maxHeight, double minHeight) {
    final calculatedHeight = actualHeight * heightscaleratio;

    return calculatedHeight > maxHeight
        ? maxHeight
        : calculatedHeight < minHeight
            ? minHeight
            : calculatedHeight;
  }

  static void setSizes(
      double screenheight, double screenwidth, double textscalefactor) {
    Sizescaleconfig.screenheight = screenheight;
    Sizescaleconfig.screenwidth = screenwidth;
    Sizescaleconfig.textscalefactor = textscalefactor;

    calculaterscaleratio();
  }
}

enum DeviceType {
  SMALL_MOBILE,
  MOBILE,
  TABLET,
  DESKTOP,
}
