import 'dart:developer';

import 'package:chaseapp/src/shared/enums/nodle_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class NodelStateNotifier extends StateNotifier<NodleState> {
  NodelStateNotifier() : super(NodleState.Idle);

  final Logger logger = Logger('NodelStateNotifier');

  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');
  late final String? _value;
  String? get value => _value;
  String? status = null;
  String? nodleConfig = null;
  bool isInitialized = false;

  void initializeNodle() async {
    if (!isInitialized) {
      try {
        _value = await platform.invokeMethod<String?>("init");
        isInitialized = true;
        log("Nodle initialized: $_value");
      } catch (e, stk) {
        logger.severe("Error initializing nodle", e, stk);
      }
    }
  }

  Future getNodleStatus() async {
    try {
      status = await platform.invokeMethod("isScanning");
    } catch (e, stk) {
      logger.warning("Error getting Nodle status", e, stk);
    }
  }

  Future getNodleConfig() async {
    const platform = MethodChannel('com.carverauto.chaseapp/nodle');

    try {
      nodleConfig = await platform.invokeMethod("showConfig");
    } catch (e, stk) {
      logger.warning("Error getting Nodle config", e, stk);
    }
  }
}
