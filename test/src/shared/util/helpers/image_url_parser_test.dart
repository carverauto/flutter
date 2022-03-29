import 'package:chaseapp/src/shared/util/helpers/image_url_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Image Append Getter Based On Dimension', () {
    expect(ImageDimensions.SMALL.getDimensions, '_200x200.webp?');
    expect(ImageDimensions.MEDIUM.getDimensions, '_600x600.webp?');
    expect(ImageDimensions.LARGE.getDimensions, '_1200x600.webp?');
  });

  test('Chase Image Url Parser', () {
    const String url =
        'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chases%2F01e3be5b-7fad-11ec-b0bf-02aa12a739fb%2FScreen%20Shot%202022-01-27%20at%202.12.06%20PM.png?alt=media&token=01e3be5b-7fad-11ec-b0bf-02aa12a739fb';
    const String expectedString =
        'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chases%2F01e3be5b-7fad-11ec-b0bf-02aa12a739fb%2FScreen%20Shot%202022-01-27%20at%202.12.06%20PM_200x200.webp?alt=media&token=01e3be5b-7fad-11ec-b0bf-02aa12a739fb';

    expect(parseImageUrl(url, ImageDimensions.SMALL), expectedString);
    const String expectedMediumString =
        'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chases%2F01e3be5b-7fad-11ec-b0bf-02aa12a739fb%2FScreen%20Shot%202022-01-27%20at%202.12.06%20PM_600x600.webp?alt=media&token=01e3be5b-7fad-11ec-b0bf-02aa12a739fb';

    expect(parseImageUrl(url), expectedMediumString);
    const String expectedLargeString =
        'https://firebasestorage.googleapis.com/v0/b/chaseapp-8459b.appspot.com/o/chases%2F01e3be5b-7fad-11ec-b0bf-02aa12a739fb%2FScreen%20Shot%202022-01-27%20at%202.12.06%20PM_1200x600.webp?alt=media&token=01e3be5b-7fad-11ec-b0bf-02aa12a739fb';

    expect(parseImageUrl(url, ImageDimensions.LARGE), expectedLargeString);
  });
}
