import 'dart:developer';

import 'package:chaseapp/src/shared/enums/nodle_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodelStateNotifier extends StateNotifier<NodleState> {
  NodelStateNotifier() : super(NodleState.Idle);

  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');
  late final String _value;
  String get value => _value;

  void initializeNodle() async {
    try {
      _value = await platform.invokeMethod("init");
      log("Nodle initialized: $_value");
    } catch (e) {
      log("Error Initializing Nodle", error: e);
    }
  }
}
