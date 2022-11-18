// ignore_for_file: unawaited_futures

import 'package:url_launcher/url_launcher.dart' as ul;

Future<void> launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await ul.canLaunchUrl(uri)) {
    ul.launchUrl(uri);
  }
}
