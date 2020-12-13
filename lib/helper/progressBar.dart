import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class Utils {
  static Widget progressBar() {
    return ProgressHUD(
      backgroundColor: Colors.black54,
      color: Colors.white,
      containerColor: Colors.red,
      borderRadius: 5.0,
      text: 'Please wait',
    );
  }
}
