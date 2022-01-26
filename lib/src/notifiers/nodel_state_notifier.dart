import 'dart:developer';

import 'package:chaseapp/src/shared/enums/nodle_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NodelStateNotifier extends StateNotifier<NodleState> {
  NodelStateNotifier() : super(NodleState.Idle);

  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');
  late final String _value;
  String get value => _value;
  String status = "NA";
  String nodleConfig = "NA";

  void initializeNodle() async {
    try {
      _value = await platform.invokeMethod("init");
      log("Nodle initialized: $_value");
    } catch (e) {
      log("Error Initializing Nodle", error: e);
    }
  }

  Future getNodleStatus() async {
    try {
      status = await platform.invokeMethod("isScanning");
    } catch (e) {
      log("Error getting Nodle status", error: e);
    }
  }

  Future getNodleConfig() async {
    const platform = MethodChannel('com.carverauto.chaseapp/nodle');

    try {
      nodleConfig = await platform.invokeMethod("showConfig");
    } catch (e) {
      log("Error getting Nodle config", error: e);
    }
  }
}
