String parseImageUrl(
  String imageUrl, [
  ImageDimensions imageDimensions = ImageDimensions.MEDIUM,
]) {
  return imageUrl.replaceAll(
    RegExp(r'\.([0-9a-z]+)(?:[?#]|$)', caseSensitive: false),
    imageDimensions.getDimensions,
  );
}

enum ImageDimensions {
  SMALL,
  MEDIUM,
  LARGE,
}

extension ImageDimensionParser on ImageDimensions {
  String get getDimensions {
    switch (this) {
      case ImageDimensions.SMALL:
        return "_200x200.webp?";

      case ImageDimensions.MEDIUM:
        return "_600x600.webp?";

      case ImageDimensions.LARGE:
        return "_1200x600.webp?";

      default:
        return "_200x200.webp?";
    }
  }
}
