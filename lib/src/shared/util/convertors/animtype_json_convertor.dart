import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/animtype.dart';

class AnimTypeConvertor implements JsonConverter<AnimType, String> {
  const AnimTypeConvertor();

  @override
  AnimType fromJson(String animtype) {
    return getAnimTypeFromStrong(animtype);
  }

  @override
  String toJson(
    AnimType alignment,
  ) {
    return alignment.name;
  }
}

AnimType getAnimTypeFromStrong(String align) {
  switch (align) {
    case 'pop_up':
      return AnimType.pop_up;

    case 'theater':
      return AnimType.theater;

    default:
      return AnimType.unknown;
  }
}
