import 'package:flutter/material.dart' show BuildContext, StatelessWidget, Widget;
import 'package:chaseapp/helper/record.dart';

class ShowNetworkURL extends StatelessWidget {
  final Record record;
  final Network<Map> _networkURL;

  @override
  Widget build(BuildContext context) {
    return _networkURL.URL;
  }
}