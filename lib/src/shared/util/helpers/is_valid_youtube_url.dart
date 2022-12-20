import 'package:path/path.dart' as path;

enum MediaPlayer {
  youtube,
  mp4,
  m3u8,
  none;

  static MediaPlayer getMediaType(String? url) {
    if (url == null) {
      return MediaPlayer.none;
    }
    if (isValidYoutubeUrl(url)) {
      return MediaPlayer.youtube;
    }

    if (_ismp4(url)) {
      return MediaPlayer.mp4;
    }
    if (_ism3u8(url)) {
      return MediaPlayer.m3u8;
    }

    return MediaPlayer.none;
  }
}

bool ismp4orm3u8url(String url) {
  final String extension = path.extension(url.split('?').first);
  final bool isMp4 = extension == '.mp4' || extension == '.m3u8';

  return isMp4;
}

bool _ismp4(String url) {
  final String extension = path.extension(url.split('?').first);
  final bool isMp4 = extension == '.mp4';

  return isMp4;
}

bool _ism3u8(String url) {
  final String extension = path.extension(url.split('?').first);
  final bool isMp4 = extension == '.m3u8';

  return isMp4;
}

bool isValidYoutubeUrl(String url) {
  return RegExp(
    r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$',
  ).hasMatch(url);
}

String? parseYoutubeUrlForVideoId(String url) {
  // get the videoId by passing url through regex
  final RegExpMatch? videoId = RegExp(
    r'(?:http:|https:)*?\/\/(?:www\.|)(?:youtube\.com|m\.youtube\.com|youtu\.|youtube-nocookie\.com).*(?:v=|v%3D|v\/|(?:a|p)\/(?:a|u)\/\d.*\/|watch\?|vi(?:=|\/)|\/embed\/|oembed\?|be\/|e\/)([^&?%#\/\n]*)',
  ).firstMatch(url);

  return videoId?.group(1).toString();
}
