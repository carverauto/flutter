import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';
import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import 'data/mapdb.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MapBoxFullView extends StatelessWidget {
  const MapBoxFullView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: false,
      ),
      body: const MapBoxView(),
    );
  }
}

class MapBoxView extends StatefulWidget {
  const MapBoxView({super.key});

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> {
  late final MapboxMapController mapboxMapController;

  Symbol? infosymbol;
  // bool? isLocationOn;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    mapboxMapController = controller;
    await loadMarkers();
    // isLocationOn = await Permission.locationWhenInUse.isGranted;
    setState(() {});
  }

  Future<void> loadMarkers() async {
    await mapboxMapController.clearSymbols();
    await mapboxMapController.clearCircles();

    final MapMarkersData markers = await MapDB().getRTDBData();
    final List<Ship> ships = markers.ships;
    final List<ADSB> adsbs = markers.adsbs;

    final ByteData heli = await rootBundle.load('assets/helicopter.png');
    final ByteData plane = await rootBundle.load('assets/plane.png');
    final ByteData boat = await rootBundle.load('assets/boat.png');

    await mapboxMapController.addImage(
      'heli',
      heli.buffer.asUint8List(),
    );
    await mapboxMapController.addImage(
      'plane',
      plane.buffer.asUint8List(),
    );
    await mapboxMapController.addImage(
      'boat',
      boat.buffer.asUint8List(),
    );
    await mapboxMapController.setSymbolIconAllowOverlap(true);
    // await mapboxMapController.setSymbolTextAllowOverlap(true);

    // mapboxMapController.onSymbolTapped.add((Symbol symbol) async {
    //   if (infosymbol != null) {
    //     await mapboxMapController.removeSymbol(infosymbol!);
    //   }

    //   final String title = symbol.data!['title'] as String;
    //   final GestureDetector infoWindow = GestureDetector(
    //     onTap: () {
    //       log('Tappable');
    //     },
    //     child: Container(
    //       padding: const EdgeInsets.all(10),
    //       color: Colors.red,
    //       child: Text(title),
    //     ),
    //   );
    //   // get the image of the infoWindow

    //   final Uint8List infoBytes = await createImageFromWidget(infoWindow);
    //   await mapboxMapController.addImage('infoWindow', infoBytes);

    //   infosymbol = await mapboxMapController.addSymbol(
    //     SymbolOptions(
    //       geometry: symbol.options.geometry,
    //       iconImage: 'infoWindow',
    //       iconSize: 1,
    //       iconOffset: const Offset(0, -50),
    //     ),
    //     symbol.data,
    //   );
    // });

    for (final Ship ship in ships) {
      await mapboxMapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(ship.lat, ship.lon),

          iconImage: 'boat',
          // iconSize: 0.1,
          iconRotate: ship.heading,
        ),
        <String, dynamic>{
          'title': ship.name,
          'mmsi': ship.mmsi,
        },
      );
      for (final ADSB bof in adsbs) {
        final String image = bof.type == 'plane' ? 'plane' : 'heli';
        await mapboxMapController.addSymbol(
          SymbolOptions(
            geometry: LatLng(bof.lat, bof.lon),
            iconImage: image,
            iconSize: 1.3,
            iconRotate: bof.track,
            zIndex: 10,
          ),
          <String, dynamic>{
            'title': bof.flight,
            'group': bof.group,
          },
        );
      }
    }
  }

  // late BitmapDescriptor? markerImage;

  // Future<void> loadMarkerImage() async {
  //   markerImage = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(12, 12)),
  //     'assets/sparkles.png',
  //   );

  //   setState(() {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mapboxMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // if (isLocationOn != null && isLocationOn == false)
          // const Flexible(
          //   child: DecoratedBox(
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //     ),
          //     child: Text(
          //       'Location is turned off. Turn on location to see your location on the map and get accurate information.',
          //     ),
          //   ),
          // ),
          Expanded(
            child: MapboxMap(
              styleString: MapboxStyles.DARK,
              accessToken: EnvVaribales.getMapBoxPublicAccessToken,
              attributionButtonMargins: const Point(-200, 0),

              logoViewMargins: const Point(-200, 0),
              onMapCreated: _onMapCreated,
              // myLocationEnabled: true,
              // ignore: prefer_collection_literals
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  VerticalDragGestureRecognizer.new,
                ),
                Factory<DragGestureRecognizer>(
                  HorizontalDragGestureRecognizer.new,
                ),
              ].toSet(),

              myLocationRenderMode: MyLocationRenderMode.NORMAL,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  31.284788,
                  -92.471176,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
