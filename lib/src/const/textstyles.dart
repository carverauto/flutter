import 'package:flutter/material.dart';

TextStyle getButtonStyle(BuildContext context) =>
    // Sizescaleconfig.getDeviceType == DeviceType.SMALL_MOBILE
    //     ?
    Theme.of(context).textTheme.button!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        );
        // : Theme.of(context).textTheme.headline6!.copyWith(
        //       color: Theme.of(context).colorScheme.onPrimary,
        //     );
