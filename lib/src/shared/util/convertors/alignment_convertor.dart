import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class AlignmentConvertor implements JsonConverter<Alignment, String> {
  const AlignmentConvertor();

  @override
  Alignment fromJson(String alignment) {
    return getAlignmentFromStrong(alignment);
  }

  @override
  String toJson(
    Alignment alignment,
  ) {
    return 'bottomRight';
  }
}

Alignment getAlignmentFromStrong(String align) {
  switch (align) {
    case 'topLeft':
      return Alignment.topLeft;
      break;
    case 'topCenter':
      return Alignment.topCenter;
      break;
    case 'topRight':
      return Alignment.topRight;
      break;
    case 'centerLeft':
      return Alignment.centerLeft;
      break;
    case 'center':
      return Alignment.center;
      break;
    case 'centerRight':
      return Alignment.centerRight;
      break;
    case 'bottomLeft':
      return Alignment.bottomLeft;
      break;
    case 'bottomCenter':
      return Alignment.bottomCenter;
      break;
    case 'bottomRight':
      return Alignment.bottomRight;
      break;
    default:
      return Alignment.bottomRight;
  }
}
