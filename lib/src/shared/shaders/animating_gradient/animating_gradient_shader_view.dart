import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatingGradientShaderBuilder extends StatefulWidget {
  const AnimatingGradientShaderBuilder({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  State<AnimatingGradientShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<AnimatingGradientShaderBuilder> {
  // late Future<AnimatingGradient> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // helloWorld = AnimatingGradient.compile();
    delta = 0;
    ticker = Ticker((Duration elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (BuildContext context, FragmentShader shader, Widget? child) {
        return AnimatedSampler(
          child: child ??
              Container(
                color: Colors.red,
              ),
          (ui.Image image, Size size, Offset offset, Canvas canvas) {
            shader
              ..setFloat(0, delta)
              ..setFloat(1, size.width)
              ..setFloat(2, size.height);

            canvas
              ..save()
              ..drawRect(
                Offset.zero & size,
                Paint()..shader = shader,
              )
              ..restore();
          },
        );
      },
      assetKey: 'shaders/animating_gradient.glsl',
      child: widget.child ?? Container(color: Colors.red),
    );
  }
}
