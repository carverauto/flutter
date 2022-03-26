// ignore_for_file: unawaited_futures

import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    launch(url);
  }
}
