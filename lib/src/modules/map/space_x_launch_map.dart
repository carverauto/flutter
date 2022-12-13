import 'dart:math';

import 'package:flutter/material.dart';

class SpaceXMapView extends StatelessWidget {
  const SpaceXMapView({
    super.key,
    required this.startingCoordinate,
    required this.currentCoordinate,
  });

  final Point<num> startingCoordinate;
  final Point<num> currentCoordinate;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrajectoryPainter(startingCoordinate, currentCoordinate),
    );

    // return Scaffold(
    //   body: WebView(
    //     javascriptMode: JavascriptMode.unrestricted,
    //     initialUrl: Uri.dataFromString(
    //       htmlString,
    //       mimeType: 'text/html',
    //       encoding: Encoding.getByName('utf-8'),
    //     ).toString(),
    //   ),
    // );
  }
}

class TrajectoryPainter extends CustomPainter {
  TrajectoryPainter(this.start, this.current);
  final Point<num> start;
  final Point<num> current;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Path path = Path();
    path.moveTo(start.x.toDouble(), start.y.toDouble());

    path.quadraticBezierTo(
      start.x.toDouble(),
      current.y.toDouble(),
      current.x.toDouble(),
      current.y.toDouble(),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrajectoryPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.current != current;
  }
}


// String htmlString = """
// <html>
// <head>
// <meta charset="utf-8">
// <title>Display buildings in 3D</title>
// <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no">
// <link href="https://api.mapbox.com/mapbox-gl-js/v2.11.0/mapbox-gl.css" rel="stylesheet">
// <script src="https://api.mapbox.com/mapbox-gl-js/v2.11.0/mapbox-gl.js"></script>
// <style>
// body { margin: 0; padding: 0; }
// #map { position: absolute; top: 0; bottom: 0; width: 100%; }
// </style>
// </head>
// <body>
// <div id="map"></div>
// <script>
// 	mapboxgl.accessToken = 'pk.eyJ1IjoibWZyZWVtYW40NTEiLCJhIjoiY2tyaWRyYnNlMXJleTJwbTRjYTAzYWhjaCJ9.hhwesJS258kLg3-XdLmPqg';
//     const map = new mapboxgl.Map({
//         // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
//         style: 'mapbox://styles/mapbox/light-v11',
//         center: [-74.0066, 40.7135],
//         zoom: 15.5,
//         pitch: 45,
//         bearing: -17.6,
//         container: 'map',
//         antialias: true
//     });

//     map.on('style.load', () => {
//         // Insert the layer beneath any symbol layer.
//         const layers = map.getStyle().layers;
//         const labelLayerId = layers.find(
//             (layer) => layer.type === 'symbol' && layer.layout['text-field']
//         ).id;

//         // The 'building' layer in the Mapbox Streets
//         // vector tileset contains building height data
//         // from OpenStreetMap.
//         map.addLayer(
//             {
//                 'id': 'add-3d-buildings',
//                 'source': 'composite',
//                 'source-layer': 'building',
//                 'filter': ['==', 'extrude', 'true'],
//                 'type': 'fill-extrusion',
//                 'minzoom': 15,
//                 'paint': {
//                     'fill-extrusion-color': '#aaa',

//                     // Use an 'interpolate' expression to
//                     // add a smooth transition effect to
//                     // the buildings as the user zooms in.
//                     'fill-extrusion-height': [
//                         'interpolate',
//                         ['linear'],
//                         ['zoom'],
//                         15,
//                         0,
//                         15.05,
//                         ['get', 'height']
//                     ],
//                     'fill-extrusion-base': [
//                         'interpolate',
//                         ['linear'],
//                         ['zoom'],
//                         15,
//                         0,
//                         15.05,
//                         ['get', 'min_height']
//                     ],
//                     'fill-extrusion-opacity': 0.6
//                 }
//             },
//             labelLayerId
//         );
//     });
// </script>

// </body>
// </html>
// """;
