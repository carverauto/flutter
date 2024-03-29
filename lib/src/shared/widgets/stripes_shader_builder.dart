import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math_64;

import '../util/helpers/colot_to_vector.dart';

class StripesShaderBuilder extends StatefulWidget {
  const StripesShaderBuilder({
    super.key,
    required this.child,
    required this.direction,
    // this.builder,
    required this.isActive,
    this.speedFactor = 1.0,
  });

  final Widget child;
  final double direction;

  final bool isActive;
  final double speedFactor;

  @override
  State<StripesShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderBuilder> {
  late Ticker ticker;

  late double delta;

  late final vector_math_64.Vector3 color1;
  late final vector_math_64.Vector3 color2;

  FragmentShader? myshader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return myshader != null
        ? ShaderMask(
            child: widget.child,
            shaderCallback: (Rect rect) {
              return myshader!
                ..setFloat(0, rect.width)
                ..setFloat(1, rect.height)
                // ..setFloat(2, delta)
                ..setFloat(2, 4)
                ..setFloat(3, !widget.isActive ? 0 : delta / widget.speedFactor)
                ..setFloat(4, widget.direction)
                ..setFloat(5, 0)
                ..setFloat(6, 0)
                ..setFloat(7, color1.r)
                ..setFloat(8, color1.g)
                ..setFloat(9, color1.b)
                ..setFloat(10, color2.r)
                ..setFloat(11, color2.g)
                ..setFloat(12, color2.b);
            },
          )
        : ShaderBuilder(
            (BuildContext context, FragmentShader shader, Widget? child) {
              WidgetsBinding.instance.addPostFrameCallback((Duration t) {
                if (myshader == null) {
                  setState(() {
                    myshader = shader;
                  });
                }
              });

              return const SizedBox.shrink();
            },
            assetKey: 'shaders/stripes.glsl',
            child: widget.child,
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
