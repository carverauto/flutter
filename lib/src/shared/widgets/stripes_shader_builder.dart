import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math_64;

import '../util/helpers/colot_to_vector.dart';

class StripesShaderBuilder extends StatefulWidget {
  const StripesShaderBuilder({
    Key? key,
    required this.child,
    required this.direction,
    // this.builder,
    required this.isActive,
  }) : super(key: key);

  final Widget? child;
  final double direction;
  // final Widget Function(BuildContext context, Stripes shader, double uTime)?
  //     builder;
  final bool isActive;

  @override
  State<StripesShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderBuilder> {
//  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  late final vector_math_64.Vector3 color1;
  late final vector_math_64.Vector3 color2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  helloWorld = Stripes.compile();
    color1 = (Colors.amber[700] as Color).toColorVector();
    color2 = (Colors.grey[600] as Color).toColorVector();
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
              ..setFloat(0, size.width)
              ..setFloat(1, size.height)
              ..setFloat(2, delta)
              ..setFloat(3, 4)
              ..setFloat(4, !widget.isActive ? 0 : delta)
              ..setFloat(5, widget.direction)
              ..setFloat(6, 0)
              ..setFloat(7, 0)
              ..setFloat(8, color1.r)
              ..setFloat(9, color1.g)
              ..setFloat(10, color1.b)
              ..setFloat(11, color2.r)
              ..setFloat(12, color2.g)
              ..setFloat(13, color2.b);

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

    //  FutureBuilder<Stripes>(
    //   future: helloWorld,
    //   builder: (BuildContext context, AsyncSnapshot<Stripes> snapshot) {
    //     if (snapshot.hasData) {
    //       return widget.builder != null
    //           ? widget.builder!(context, snapshot.data!, delta)
    //           : ShaderMask(
    //               child: widget.child,
    //               shaderCallback: (Rect rect) {
    //                 return snapshot.data!.shader(
    //                   resolution: rect.size,
    //                   uTime: delta,
    //                   tiles: 4,
    //                   speed: !widget.isActive ? 0 : delta,
    //                   direction: widget.direction, // -1 to 1
    //                   warpScale: 0,
    //                   warpTiling: 0,
    //                   color1: (Colors.amber[700] as Color).toColorVector(),
    //                   color2: (Colors.grey[600] as Color).toColorVector(),
    //                 );
    //               },
    //             );
    //     } else if (snapshot.hasError) {
    //       return Text('${snapshot.error}');
    //     }
    //     return const CircularProgressIndicator();
    //   },
    // );
  }
}
