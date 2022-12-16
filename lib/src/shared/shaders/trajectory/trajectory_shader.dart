import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class TrajectoryShaderView extends StatefulWidget {
  const TrajectoryShaderView({
    Key? key,
    required this.builder,
    required this.startingPoint,
    required this.controlPoint,
    required this.endingPoint,
  }) : super(key: key);

  final Widget Function(FragmentShader shader, double delta) builder;
  final Offset startingPoint;
  final Offset controlPoint;
  final Offset endingPoint;

  @override
  State<TrajectoryShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<TrajectoryShaderView> {
  // late Future<AnimatingGradient> helloWorld;

  late Ticker ticker;

  late double delta;
  FragmentShader? shader;

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
    if (shader != null) {
      // return widget.builder(shader!, delta);
      return ShaderMask(
        //  blendMode: BlendMode.hardLight,
        shaderCallback: (ui.Rect rect) {
          return shader!
            ..setFloat(0, rect.width)
            ..setFloat(1, rect.height)
            ..setFloat(2, delta)
            ..setFloat(3, widget.startingPoint.dx)
            ..setFloat(4, widget.startingPoint.dy)
            ..setFloat(5, widget.controlPoint.dx)
            ..setFloat(6, widget.controlPoint.dy)
            ..setFloat(7, widget.endingPoint.dx)
            ..setFloat(8, widget.endingPoint.dy);
        },
        child: widget.builder(shader!, delta),
      );
    }

    return ShaderBuilder(
      (BuildContext context, FragmentShader myshader, Widget? child) {
        shader = myshader;

        return const SizedBox.shrink();

        // return AnimatedSampler(
        //   (ui.Image p0, Size p1, Offset offset, Canvas canvas) {
        //     shader
        //       ..setFloat(0, p1.width)
        //       ..setFloat(1, p1.height)
        //       ..setFloat(2, delta)
        //       ..setImageSampler(0, p0);
        //     canvas
        //       ..save()
        //       ..translate(offset.dx, offset.dy)
        //       ..drawRect(Offset.zero & p1, Paint()..shader = shader)
        //       ..restore();
        //   },
        //   child: child!,
        // );
      },
      assetKey: 'shaders/trajectory_glow.glsl',
      child: const SizedBox.shrink(),
    );
  }
}
