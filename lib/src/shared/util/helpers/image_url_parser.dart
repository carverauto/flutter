import 'package:chaseapp/src/const/links.dart';

String parseImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) return defaultChaseGif;
  return imageUrl.replaceAll(
      RegExp(r'/\.([0-9a-z]+)(?:[?#]|$)/i'), "_200x200.webp?");
}
