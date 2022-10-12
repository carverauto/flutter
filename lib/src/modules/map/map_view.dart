import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';

class MapBoxView extends StatefulWidget {
  const MapBoxView({super.key});

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> {
  late final MapboxMapController mapboxMapController;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    mapboxMapController = controller;

    await mapboxMapController.addCircle(
      // <--- this is where the error is
      const CircleOptions(
        circleRadius: 10,
        circleColor: '#FFFF3D3D',
        geometry: LatLng(38.8410857803, -76.9750541388),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //   mapboxMapController = MapboxMapController(
    //     initialCameraPosition: const CameraPosition(
    //       target: LatLng(37.7749, -122.4194),
    //       zoom: 14,
    //     ),
    //        mapboxGlPlatform :MapboxGlPlatform ,
    //   annotationOrder:[] ,
    //   annotationConsumeTapEvents: [],
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      styleString: MapboxStyles.DARK,
      accessToken: EnvVaribales.getMapBoxPublicAccessToken,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      initialCameraPosition: const CameraPosition(
        target: LatLng(
          0,
          0,
        ),
      ),
    );
  }
}
