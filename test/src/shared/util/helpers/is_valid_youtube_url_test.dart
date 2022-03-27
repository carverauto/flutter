import 'package:chaseapp/src/shared/util/helpers/is_valid_youtube_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Youtube Url Validator', () {
    const String validUrl = 'https://www.youtube.com/watch?v=5_vieKAew8E';

    expect(isValidYoutubeUrl(validUrl), true);
    const String inValidUrl = 'https:www.youtube.com/watch?v=5_vieKAew8E';

    expect(isValidYoutubeUrl(inValidUrl), false);
  });
  test('Youtube Url Parser', () {
    const String url = 'https://www.youtube.com/watch?v=5_vieKAew8E';

    expect(parseYoutubeUrlForVideoId(url), '5_vieKAew8E');
  });
}
