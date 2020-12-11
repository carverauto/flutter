import 'package:flutter/material.dart';

DeviceSize deviceSize;

class DeviceSize {
  final Size size;
  final double width;
  final double height;
  final double aspectRatio;

  DeviceSize({this.size, this.width, this.height, this.aspectRatio});
}