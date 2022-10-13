import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';
import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import 'data/mapdb.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MapBoxView extends StatefulWidget {
  const MapBoxView({super.key});

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> {
  late final MapboxMapController mapboxMapController;

  Symbol? infosymbol;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    mapboxMapController = controller;
  }

  Future<void> loadMarkers() async {
    await mapboxMapController.clearSymbols();
    await mapboxMapController.clearCircles();

    final MapMarkersData markers = await MapDB().getRTDBData();
    final List<Ship> ships = markers.ships;
    final List<ADSB> adsbs = markers.adsbs;

    final ByteData bytes = await rootBundle.load('assets/sparkles.png');

    await mapboxMapController.addImage('testimage', bytes.buffer.asUint8List());
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
      await mapboxMapController.addCircle(
        CircleOptions(
          geometry: LatLng(ship.lat, ship.lon),
          circleColor: '#ff00ff00',
          circleRadius: 5,

          // iconImage: 'testimage',
          // iconSize: 0.1,
          // iconRotate: 45,
        ),
        <String, dynamic>{
          'title': ship.name,
          'mmsi': ship.mmsi,
        },
      );
      for (final ADSB bof in adsbs) {
        await mapboxMapController.addSymbol(
          SymbolOptions(
            geometry: LatLng(bof.lat, bof.lon),
            iconImage: 'testimage',
            iconSize: 0.1,
            iconRotate: 45,
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: loadMarkers),
      body: MapboxMap(
        styleString: MapboxStyles.DARK,
        accessToken: EnvVaribales.getMapBoxPublicAccessToken,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(
            31.284788,
            -92.471176,
          ),
        ),
      ),
    );
  }
}
