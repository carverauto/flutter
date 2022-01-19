import 'package:flutter/material.dart';

DeviceSize? deviceSize;

class DeviceSize {
  final Size size;
  final double width;
  final double height;
  final double aspectRatio;

  DeviceSize({required this.size, required this.width, required this.height, required this.aspectRatio});
}