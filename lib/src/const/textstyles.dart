import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

TextStyle getButtonStyle(BuildContext context) =>
    Sizescaleconfig.getDeviceType == DeviceType.MOBILE
        ? Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            )
        : Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            );
