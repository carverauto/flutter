import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';
import '../../const/images.dart';
import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import '../../shared/util/helpers/widget_to_image.dart';
import 'data/mapdb.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

//TODO: Find a good way to dispose off stream listeners or use streamcontrollers for listening to streams and disposing

class MapBoxView extends StatefulWidget {
  const MapBoxView({
    super.key,
    this.showAppBar = false,
  });

  final bool showAppBar;

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView> with WidgetsBindingObserver {
  late final MapboxMapController mapboxMapController;
  StreamSubscription<List<Ship>>? shipsStreamSubscription;
  StreamSubscription<List<ADSB>>? adsbStreamSubscription;

  Symbol? infosymbol;
  final MapDB mapDB = MapDB();
  late List<double>? lastMapCenteredCoordinates;

  Future<void> get saveCameralastPosition async {
    if (mapboxMapController.cameraPosition != null) {
      await mapDB.setLastMapCenteredCoordinates([
        mapboxMapController.cameraPosition!.target.latitude,
        mapboxMapController.cameraPosition!.target.longitude,
      ]);
    }
  }

  Future<void> getLastMapCoordinates() async {
    lastMapCenteredCoordinates = await mapDB.getLastMapCenteredCoordinates;
    if (lastMapCenteredCoordinates != null) {
      final CameraPosition cameraPosition = CameraPosition(
        target: LatLng(
          lastMapCenteredCoordinates![0],
          lastMapCenteredCoordinates![1],
        ),
        zoom: 4,
      );
      await mapboxMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  // bool? isLocationOn;
  final Logger logger = Logger('MapBox View');

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
    mapboxMapController.onSymbolTapped.add(onSymbolTappedErrorWrapper);
    loadADSBSymbols();
    loadShipssymbols();
    Timer(const Duration(milliseconds: 200), () async {
      if (mounted) {
        await getLastMapCoordinates();
      }
    });
  }

  Future<void> onSymbolTappedErrorWrapper(Symbol symbol) async {
    try {
      await onSymbolTapped(symbol);
    } catch (e, stk) {
      logger.warning('Tapped Symbol Data->${symbol.data}', e, stk);
    }
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
    if (symbol.options.iconImage == 'infoWindow') {
      return;
    }
    final String title = symbol.data!['title'] as String;
    final bool isShip = symbol.data!['type'] == 'ship';
    final String? subtitle = symbol.data!['subtitle'] as String?;

    final String? imageUrl = symbol.data!['imageUrl'] as String?;
    log(imageUrl.toString());
    // final http.Response? groupImage =
    //     imageUrl != null ? await http.get(Uri.parse(imageUrl)) : null;
    // final Uint8List? groupImageBytes = groupImage?.bodyBytes;

    if (!isShip) {
      if (imageUrl != null) {
        await precacheImage(NetworkImage(imageUrl), context);
      }
      // imasbImagegBytes = await createImageFromWidget(adsbImage);
    }

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
              if (!isShip)
                MediaQuery(
                  data:
                      MediaQueryData.fromWindow(WidgetsBinding.instance.window),
                  child: ClipOval(
                    child: CircleAvatar(
                      // backgroundImage: Image.memory(
                      //   groupImageBytes,
                      // ).image,
                      child: imageUrl == null
                          ? Image.asset(chaseAppLogoAssetImage)
                          : Image.network(imageUrl),
                    ),
                  ),
                )
              else
                const Icon(Icons.directions_boat),
              // ClipOval(
              //   child: CircleAvatar(
              //     // backgroundImage: Image.memory(
              //     //   groupImageBytes,
              //     // ).image,
              //     child: imageUrl == null
              //         ? Image.asset('assets/chaseapplogo.png')
              //         : Image.memory(imageBytes!),
              //   ),
              // ),
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
    adsbStreamSubscription =
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
    shipsStreamSubscription =
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state != AppLifecycleState.resumed) {
      await saveCameralastPosition;
    }
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    await saveCameralastPosition;
    await shipsStreamSubscription?.cancel();
    await adsbStreamSubscription?.cancel();
    mapboxMapController.onSymbolTapped.remove(onSymbolTappedErrorWrapper);
    mapboxMapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Map'),
              centerTitle: false,
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: MapboxMap(
              trackCameraPosition: true,
              minMaxZoomPreference: const MinMaxZoomPreference(4, 100),
              styleString: MapboxStyles.DARK,
              accessToken: EnvVaribales.getMapBoxPublicAccessToken,
              attributionButtonMargins: const math.Point(-200, 0),

              logoViewMargins: const math.Point(-200, 0),
              onMapCreated: _onMapCreated,

              onMapClick: (math.Point<double> point, LatLng latlong) async {
                if (infosymbol != null) {
                  final List<Symbol> allInfoSymbols =
                      mapboxMapController.symbols
                          .where(
                            (Symbol info) =>
                                info.options.iconImage == 'infoWindow',
                          )
                          .toList();
                  for (final Symbol element in allInfoSymbols) {
                    await mapboxMapController.removeSymbol(element);
                  }
                  // await mapboxMapController.removeSymbol(infosymbol!);
                }
              },
              // myLocationEnabled: true,
              // ignore: prefer_collection_literals
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  VerticalDragGestureRecognizer.new,
                ),
                Factory<DragGestureRecognizer>(
                  HorizontalDragGestureRecognizer.new,
                ),
              },

              myLocationRenderMode: MyLocationRenderMode.NORMAL,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  34.052235,
                  -118.243683,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
