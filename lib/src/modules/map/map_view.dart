// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../const/app_bundle_info.dart';
import '../../const/images.dart';
import '../../const/sizings.dart';
import '../../models/activeTFR/activeTFR.dart';
import '../../models/adsb/adsb.dart';
import '../../models/birds_of_fire/birds_of_fire.dart';
import '../../models/ship/ship.dart';
import '../../shared/util/helpers/widget_to_image.dart';
import '../bof/bof_view.dart';
import 'providers.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

//TODO: Find a good way to dispose off stream listeners or use streamcontrollers for listening to streams and disposing

class MapBoxView extends ConsumerStatefulWidget {
  const MapBoxView({
    super.key,
    this.showAppBar = false,
    required this.onSymbolTap,
    required this.onExpansionButtonTap,
    required this.animation,
    this.symbolId,
    this.latLng,
  });

  final bool showAppBar;
  final void Function(
    String? id,
    LatLng? latLng,
  ) onSymbolTap;
  final VoidCallback onExpansionButtonTap;
  final Animation<double> animation;
  final String? symbolId;
  final LatLng? latLng;

  @override
  ConsumerState<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends ConsumerState<MapBoxView>
    with WidgetsBindingObserver {
  late final MapboxMapController mapboxMapController;
  bool hasStylesLoaded = false;

  Symbol? infosymbol;

  Future<void> saveCameralastPosition(LatLng? latlng) async {
    if (latlng != null) {
      await ref.read(mapDBProvider).setLastMapCenteredCoordinates([
        latlng.latitude,
        latlng.longitude,
      ]);
    }
  }

  Future<void> getLastMapCoordinates() async {
    final List<double>? lastMapCenteredCoordinates =
        await ref.read(mapDBProvider).getLastMapCenteredCoordinates;
    if (lastMapCenteredCoordinates != null) {
      final CameraPosition cameraPosition = CameraPosition(
        target: LatLng(
          lastMapCenteredCoordinates[0],
          lastMapCenteredCoordinates[1],
        ),
        zoom: 4,
      );
      await mapboxMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  // bool? isLocationOn;
  final Logger logger = Logger('MapBox View');

  // ignore: long-method
  Future<void> _onStyleLoaded() async {
    log('Map Styles Loaded');
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

    final List<ADSB> adsbList = ref.read(adsbStreamProvider).value ?? [];
    await loadADSBSymbols(adsbList);
    final List<Ship> shipsList = ref.read(shipsStreamProvider).value ?? [];
    await loadShipssymbols(shipsList);

    final List<ActiveTFR> activeTFRs =
        ref.read(activeTFRsStreamProvider).value ?? [];
    await loadActiveTFRsymbols(activeTFRs);

    //fetch weather radar raster tiles from mesonet then add as a mapbox source

    const RasterSourceProperties weatherRadarSource = RasterSourceProperties(
      tiles: [
        'https://mesonet.agron.iastate.edu/cache/tile.py/1.0.0/nexrad-n0q-900913/{z}/{x}/{y}.png'
      ],
    );
    const RasterLayerProperties weatherRadarLayer = RasterLayerProperties();
    await mapboxMapController.addSource(
      'Radar_Raster_Source',
      weatherRadarSource,
    );
    await mapboxMapController.addLayer(
      'Radar_Raster_Source',
      'Radar_Raster_Layer',
      weatherRadarLayer,
    );

    setState(() {
      hasStylesLoaded = true;
    });

    if (widget.symbolId == null) {
      Timer(const Duration(milliseconds: 200), () async {
        if (mounted) {
          await getLastMapCoordinates();
        }
      });
    } else {
      if (Platform.isAndroid) {
        await moveToSymbol(widget.symbolId);
      }
    }
  }

  Future<void> _onMapCreated(MapboxMapController controller) async {
    log('Map Controller Loaded');
    mapboxMapController = controller;
  }

  Future<void> onSymbolTappedErrorWrapper(Symbol symbol) async {
    try {
      await onSymbolTapped(symbol);
    } catch (e, stk) {
      logger.warning('Tapped Symbol Data->${symbol.data}', e, stk);
    }
  }

  // ignore: long-method
  Future<void> onSymbolTapped(Symbol symbol, [bool zoomIn = true]) async {
    //temp fix for android expansion workflow
    if (Platform.isAndroid) {
      if (!widget.showAppBar) {
        widget.onSymbolTap(
          symbol.data?['id'] as String?,
          symbol.options.geometry,
        );
        return;
      }
    }
    //

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

    if (zoomIn) {
      if (infosymbol != null) {
        await mapboxMapController.animateCamera(
          CameraUpdate.newLatLngZoom(
            infosymbol!.options.geometry!,
            mapboxMapController.cameraPosition!.zoom > 7
                ? mapboxMapController.cameraPosition!.zoom
                : 7,
          ),
        );
      }
    }

    widget.onSymbolTap(
      symbol.id,
      symbol.options.geometry,
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

  // ignore: long-method
  Future<void> loadADSBSymbols(List<ADSB> adsbList) async {
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

        final Symbol symbol = await mapboxMapController.addSymbol(
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
        if (Platform.isAndroid) {
          if (symbol.id == widget.symbolId) {
            await onSymbolTapped(symbol);
          }
        }
      }
    }
  }

  Future<void> addTFRSymbolAtThisLatLng(LatLng latLng) async {
    final Widget infoWindow = MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: const Text(
        'TFR',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    final Uint8List imageBytes = await createImageFromWidget(infoWindow);
    await mapboxMapController.addImage(
      'TFR',
      imageBytes,
    );

    infosymbol = await mapboxMapController.addSymbol(
      SymbolOptions(
        geometry: latLng,
        iconImage: 'TFR',
        iconSize: 0.7,
      ),
    );
  }

  List<List<LatLng>> createGeoJSONCircle(
    LatLng center,
    int radiusInKm, [
    int points = 64,
  ]) {
    final int km = radiusInKm;

    final List<LatLng> ret = [];
    final double distanceX =
        km / (111.320 * math.cos(center.latitude * math.pi / 180));
    final double distanceY = km / 110.574;

    double theta, x, y;
    for (int i = 0; i < points; i++) {
      theta = (i / points) * (2 * math.pi);
      x = distanceX * math.cos(theta);
      y = distanceY * math.sin(theta);

      ret.add(LatLng(center.latitude + y, center.longitude + x));
    }
    ret.add(ret[0]);

    return [ret];
  }

  Future<void> loadActiveTFRsymbols(List<ActiveTFR> activeTFRs) async {
    log('ActiveTFRs Data Update');

    final Set<Fill> presentFills = mapboxMapController.fills;
    for (final ActiveTFR activeTFR in activeTFRs) {
      final Fill? fill = presentFills.firstWhereOrNull(
        (Fill element) => element.data?['id'] == activeTFR.properties.id,
      );

      if (fill != null) {
        //TODO: debug why updateFill doesn't work, this is workaround for that.
        await mapboxMapController.removeFill(fill);
      }
      await mapboxMapController.addFill(
        FillOptions(
          geometry: createGeoJSONCircle(
            LatLng(
              activeTFR.geometry.coordinates[1],
              activeTFR.geometry.coordinates[0],
            ),
            activeTFR.properties.radiusArc,
          ),
          fillColor: '#FF9800',
          fillOpacity: 0.6,
        ),
        <String, dynamic>{
          'id': activeTFR.properties.id,
        },
      );

      await addTFRSymbolAtThisLatLng(
        LatLng(
          activeTFR.geometry.coordinates[1],
          activeTFR.geometry.coordinates[0],
        ),
      );
    }
  }

  Future<void> loadShipssymbols(List<Ship> shipsList) async {
    log('Ships Data Update');
    for (final Ship ship in shipsList) {
      final Set<Symbol> presentSymbols = mapboxMapController.symbols;

      final Symbol? symbol = presentSymbols.firstWhereOrNull(
        (Symbol element) => element.data?['id'] == ship.id,
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
  }

  Future<void> moveToSymbol(String? id) async {
    final Symbol? symbol = mapboxMapController.symbols.firstWhereOrNull(
      (Symbol element) => element.data?['id'] == id,
    );
    if (symbol != null) {
      await mapboxMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          symbol.options.geometry!,
          10,
        ),
      );
      await onSymbolTapped(symbol, false);
    }
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
      await saveCameralastPosition(mapboxMapController.cameraPosition?.target);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    mapboxMapController.onSymbolTapped.remove(onSymbolTappedErrorWrapper);
    saveCameralastPosition(mapboxMapController.cameraPosition?.target);
    // called by mapboxview on dispose
    // mapboxMapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BirdsOfFire?>(
      activeClusterCoordinateProvider,
      (BirdsOfFire? prev, BirdsOfFire? next) {
        if (next != null) {
          // find the symbol from choppers who'se id is next

          moveToSymbol(next.properties.title);
        }
      },
    );

    ref.listen<AsyncValue<List<Ship>>>(
      shipsStreamProvider,
      (AsyncValue<List<Ship>>? previous, AsyncValue<List<Ship>> next) async {
        final List<Ship> shipsList = next.value ?? [];
        if (hasStylesLoaded && previous != null) {
          await loadShipssymbols(shipsList);
        }
      },
    );

    ref.listen<AsyncValue<List<ADSB>>>(
      adsbStreamProvider,
      (AsyncValue<List<ADSB>>? previous, AsyncValue<List<ADSB>> next) async {
        final List<ADSB> adsbsList = next.value ?? [];
        if (hasStylesLoaded && previous != null) {
          await loadADSBSymbols(adsbsList);
        }
      },
    );
    ref.listen<AsyncValue<List<ActiveTFR>>>(
      activeTFRsStreamProvider,
      (
        AsyncValue<List<ActiveTFR>>? previous,
        AsyncValue<List<ActiveTFR>> next,
      ) async {
        final List<ActiveTFR> activeTFRsList = next.value ?? [];
        if (hasStylesLoaded && previous != null) {
          await loadActiveTFRsymbols(activeTFRsList);
        }
      },
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Map'),
              centerTitle: false,
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MapboxMap(
            trackCameraPosition: true,
            styleString: MapboxStyles.DARK,
            accessToken: EnvVaribales.getMapBoxPublicAccessToken,
            attributionButtonMargins: const math.Point(-200, 0),

            logoViewMargins: const math.Point(-200, 0),
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoaded,

            onMapClick: (math.Point<double> point, LatLng latlong) async {
              if (infosymbol != null) {
                final List<Symbol> allInfoSymbols = mapboxMapController.symbols
                    .where(
                      (Symbol info) => info.options.iconImage == 'infoWindow',
                    )
                    .toList();
                for (final Symbol element in allInfoSymbols) {
                  await mapboxMapController.removeSymbol(element);
                }
              }
            },
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
            initialCameraPosition: CameraPosition(
              target: widget.latLng ??
                  const LatLng(
                    34.052235,
                    -118.243683,
                  ),
              zoom: widget.latLng != null ? 10 : 4,
            ),
          ),
          AnimatedBuilder(
            animation: widget.animation,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                bottom: Theme.of(context).platform == TargetPlatform.android
                    ? kPaddingSmallConstant +
                        (widget.showAppBar
                            ? (MediaQuery.of(context).size.height / 2 - 50)
                            : 0)
                    : kPaddingSmallConstant +
                        (MediaQuery.of(context).size.height / 2 - 50) *
                            widget.animation.value,
                right: 0,
                child: child!,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(
                          0.9,
                        ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadiusMediumConstant),
                      bottomLeft: Radius.circular(kBorderRadiusMediumConstant),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          mapboxMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target:
                                    mapboxMapController.cameraPosition!.target,
                                zoom: mapboxMapController.cameraPosition!.zoom +
                                    1,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                            kPaddingSmallConstant,
                          ),
                          child: Icon(
                            Icons.zoom_in,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      ColoredBox(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.7),
                        child: const SizedBox(
                          height: 2,
                          width: 34,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          mapboxMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target:
                                    mapboxMapController.cameraPosition!.target,
                                zoom: mapboxMapController.cameraPosition!.zoom -
                                    1,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                            kPaddingSmallConstant,
                          ),
                          child: Icon(
                            Icons.zoom_out,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      ColoredBox(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.7),
                        child: const SizedBox(
                          height: 2,
                          width: 34,
                        ),
                      ),
                      if (!widget.showAppBar)
                        InkWell(
                          onTap: widget.onExpansionButtonTap,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              kPaddingSmallConstant,
                            ),
                            child: Icon(
                              Icons.open_with,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: kPaddingSmallConstant,
                ),
              ],
            ),
          ),
          if (Theme.of(context).platform == TargetPlatform.android)
            if (widget.showAppBar)
              const Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: BofView(),
              ),
        ],
      ),
    );
  }
}
