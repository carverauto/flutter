import 'package:chaseapp/src/const/links.dart';

String parseImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) return defaultChaseImage;
  return imageUrl.replaceAll(
      RegExp(r'/\.([0-9a-z]+)(?:[?#]|$)/i'), "_1200x600.webp?");
}
