import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class AnimatingGradientShaderBuilder extends StatefulWidget {
  const AnimatingGradientShaderBuilder({
    super.key,
    required this.child,
  });

  final Widget child;

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
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return shader
              ..setFloat(0, delta)
              ..setFloat(1, bounds.width)
              ..setFloat(2, bounds.height);
          },
          child: child,
        );
      },
      assetKey: 'shaders/animating_gradient.glsl',
      child: widget.child,
    );
  }
}
