import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math_64;

extension GetColorVector on ColorSwatch<int> {
  vector_math_64.Vector3 toColorVector() {
    return vector_math_64.Vector3(red / 256, green / 256, blue / 256);
  }
}

extension GetColorVectorV2 on Color {
  vector_math_64.Vector3 toColorVector() {
    return vector_math_64.Vector3(red / 256, green / 256, blue / 256);
  }
}
