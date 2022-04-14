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
