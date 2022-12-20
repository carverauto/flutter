import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ConfettiShaderView extends StatefulWidget {
  const ConfettiShaderView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<ConfettiShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<ConfettiShaderView> {
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
              ..setFloat(0, bounds.width)
              ..setFloat(1, bounds.height)
              ..setFloat(2, delta);
          },
          child: child,
        );
      },
      assetKey: 'shaders/confetti.glsl',
      child: widget.child,
    );
  }
}
