import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../util/helpers/colot_to_vector.dart';
import 'stripes.dart';

class StripesShaderBuilder extends StatefulWidget {
  const StripesShaderBuilder({
    Key? key,
    this.child,
    required this.direction,
    this.builder,
    required this.isActive,
  })  : assert(
          child == null || builder == null,
          "You can't provide both child and builder. Use builder as it offers more control over shader usage.",
        ),
        super(key: key);

  final Widget? child;
  final double direction;
  final Widget Function(BuildContext context, Stripes shader, double uTime)?
      builder;
  final bool isActive;

  @override
  State<StripesShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderBuilder> {
  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = Stripes.compile();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Stripes>(
        future: helloWorld,
        builder: (BuildContext context, AsyncSnapshot<Stripes> snapshot) {
          if (snapshot.hasData) {
            return widget.builder != null
                ? widget.builder!(context, snapshot.data!, delta)
                : ShaderMask(
                    child: widget.child,
                    shaderCallback: (Rect rect) {
                      return snapshot.data!.shader(
                        resolution: rect.size,
                        uTime: delta,
                        tiles: 4,
                        speed: !widget.isActive ? 0 : delta,
                        direction: widget.direction, // -1 to 1
                        warpScale: 0,
                        warpTiling: 0,
                        color1: (Colors.amber[700] as Color).toColorVector(),
                        color2: (Colors.grey[600] as Color).toColorVector(),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
