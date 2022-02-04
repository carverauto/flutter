import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

TextStyle getButtonStyle(BuildContext context) =>
    Sizescaleconfig.getDeviceType == DeviceType.MOBILE
        ? Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            )
        : Theme.of(context).textTheme.headline6!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            );
