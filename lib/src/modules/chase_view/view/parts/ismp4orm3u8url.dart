import 'package:path/path.dart' as path;

bool ismp4orm3u8url(String url) {
  final String extension = path.extension(url.split('?').first);
  final bool isMp4 = extension == '.mp4' || extension == '.m3u8';

  return isMp4;
}
