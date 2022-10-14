import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';
import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import '../../shared/util/helpers/widget_to_image.dart';
import 'data/mapdb.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

//TODO: Find a good way to dispose off stream listeners or use streamcontrollers for listening to streams and disposing
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
  final MapDB mapDB = MapDB();
  // bool? isLocationOn;

  Future<void> _onMapCreated(MapboxMapController controller) async {
    mapboxMapController = controller;
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
    mapboxMapController.onSymbolTapped.add(onSymbolTapped);
    loadADSBSymbols();
    loadShipssymbols();
  }

  // ignore: long-method
  Future<void> onSymbolTapped(Symbol symbol) async {
    log('Symbol tapped');
    if (infosymbol != null) {
      final List<Symbol> allInfoSymbols = mapboxMapController.symbols
          .where((Symbol info) => info.options.iconImage == 'infoWindow')
          .toList();
      for (final Symbol element in allInfoSymbols) {
        await mapboxMapController.removeSymbol(element);
      }
      // await mapboxMapController.removeSymbol(infosymbol!);
    }
    final String title = symbol.data!['title'] as String;
    final bool isShip = symbol.data!['type'] == 'ship';
    final String? subtitle = symbol.data!['subtitle'] as String?;

    final String? imageUrl = symbol.data!['imageUrl'] as String?;
    log(imageUrl.toString());
    final http.Response? groupImage =
        imageUrl != null ? await http.get(Uri.parse(imageUrl)) : null;
    final Uint8List? groupImageBytes = groupImage?.bodyBytes;
    final Widget infoWindow = MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (groupImageBytes != null)
                CircleAvatar(
                  backgroundImage: Image.memory(
                    groupImageBytes,
                  ).image,
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    ' ${isShip ? "MMSI" : "Group"}: $subtitle',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    final Uint8List imageBytes = await createImageFromWidget(infoWindow);
    await mapboxMapController.addImage(
      'infoWindow',
      imageBytes,
    );

    infosymbol = await mapboxMapController.addSymbol(
      SymbolOptions(
        geometry: symbol.options.geometry,
        iconImage: 'infoWindow',
        iconSize: 0.8,
        iconOffset: const Offset(0, -2),
        iconAnchor: 'bottom',
      ),
    );
  }

  // late BitmapDescriptor? markerImage;

  // Future<void> loadMarkerImage() async {
  //   markerImage = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(12, 12)),
  //     'assets/sparkles.png',
  //   );

  //   setState(() {});
  // }

  void loadADSBSymbols() {
    mapDB.adsbStream().listen((List<ADSB> adsbList) async {
      log('ADSB Data Update');
      for (final ADSB adsb in adsbList) {
        final String image = adsb.type == 'plane' ? 'plane' : 'heli';
        final Set<Symbol> presentSymbols = mapboxMapController.symbols;

        final Symbol? symbol = presentSymbols.firstWhereOrNull(
          (Symbol element) => element.data?['id'] == adsb.id,
        );
        if (symbol != null) {
          await mapboxMapController.updateSymbol(
            symbol,
            SymbolOptions(
              geometry: LatLng(adsb.lat, adsb.lon),
              iconImage: image,
              iconSize: 1.3,
              iconRotate: adsb.track,
              zIndex: 10,
            ),
          );
        } else {
          final String? imageUrl = adsb.imageUrl != null
              ? 'https://chaseapp.tv${adsb.imageUrl}'
              : null;

          await mapboxMapController.addSymbol(
            SymbolOptions(
              geometry: LatLng(adsb.lat, adsb.lon),
              iconImage: image,
              iconSize: 1.3,
              iconRotate: adsb.track,
              zIndex: 10,
            ),
            <String, dynamic>{
              'title': adsb.id,
              'id': adsb.id,
              'group': adsb.group,
              'subtitle': adsb.group,
              'imageUrl': imageUrl,
              'type': 'adsb',
            },
          );
        }
      }
    });
  }

  void loadShipssymbols() {
    mapDB.shipsStream().listen((List<Ship> adsbList) async {
      log('Ships Data Update');
      for (final Ship ship in adsbList) {
        final Set<Symbol> presentSymbols = mapboxMapController.symbols;

        final Symbol? symbol = presentSymbols.firstWhereOrNull(
          (Symbol element) => element.data!['id'] == ship.id,
        );
        if (symbol != null) {
          await mapboxMapController.updateSymbol(
            symbol,
            SymbolOptions(
              geometry: LatLng(ship.lat, ship.lon),

              iconImage: 'boat',
              // iconSize: 0.1,
              iconRotate: ship.heading,
            ),
          );
        } else {
          await mapboxMapController.addSymbol(
            SymbolOptions(
              geometry: LatLng(ship.lat, ship.lon),

              iconImage: 'boat',
              // iconSize: 0.1,
              iconRotate: ship.heading,
            ),
            <String, dynamic>{
              'title': ship.name,
              'id': ship.id,
              'mmsi': ship.mmsi,
              'subtitle': ship.mmsi != null ? '${ship.mmsi}' : null,
              'type': 'ship',
            },
          );
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mapboxMapController.dispose();
    mapboxMapController.onSymbolTapped.remove(onSymbolTapped);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapboxMap(
              styleString: MapboxStyles.DARK,
              accessToken: EnvVaribales.getMapBoxPublicAccessToken,
              attributionButtonMargins: const math.Point(-200, 0),

              logoViewMargins: const math.Point(-200, 0),
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
