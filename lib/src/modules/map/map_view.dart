// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart' as collection;
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
import '../../models/weather/weather.dart';
import '../../models/weather/weather_station/weather_station.dart';
import '../../shared/util/helpers/widget_to_image.dart';
import '../bof/bof_view.dart';
import 'providers.dart';
// import 'package:platform_maps_flutter/platform_maps_flutter.dart';

List<List<LatLng>> createGeoJSONCircle(
  Map<String, dynamic> values,
) {
  final int km = values['radiusArc'] as int;
  final List<double> center = values['coordinates'] as List<double>;
  const int points = 64;

  final List<LatLng> ret = [];
  final double distanceX = km / (111.320 * math.cos(center[1] * math.pi / 180));
  final double distanceY = km / 110.574;

  double theta, x, y;
  for (int i = 0; i < points; i++) {
    theta = (i / points) * (2 * math.pi);
    x = distanceX * math.cos(theta);
    y = distanceY * math.sin(theta);

    ret.add(LatLng(center[1] + y, center[0] + x));
  }
  ret.add(ret[0]);

  return [ret];
}

Symbol? findSymbol(Map<String, dynamic> value) {
  final List<Symbol> adsbSymbols = value['symbols'] as List<Symbol>;
  final String id = value['id'] as String;
  final Symbol? symbol = adsbSymbols.firstWhereOrNull(
    (Symbol element) => element.data?['id'] == id,
  );
  return symbol;
}

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
  String? tappedSymbolId;

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
    final ByteData stormSurge = await rootBundle.load('assets/storm_surge.png');

    //fetch weather radar raster tiles from mesonet then add as a mapbox source

    const RasterSourceProperties weatherRadarSource = RasterSourceProperties(
      tiles: [
        'https://mesonet.agron.iastate.edu/cache/tile.py/1.0.0/nexrad-n0q-900913/{z}/{x}/{y}.png',
      ],
      tileSize: 256,
      maxzoom: 24,
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
    const RasterSourceProperties warningsSource = RasterSourceProperties(
      tiles: [
        'https://opengeo.ncep.noaa.gov/geoserver/wwa/warnings/ows?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&TILED=true&LAYERS=warnings&WIDTH=256&HEIGHT=256&SRS=EPSG%3A3857&BBOX={bbox-epsg-3857}',
      ],
      tileSize: 256,
      maxzoom: 24,
    );
    const RasterLayerProperties warningsLayer = RasterLayerProperties();
    await mapboxMapController.addSource(
      'Warnings_Raster_Source',
      warningsSource,
    );
    await mapboxMapController.addLayer(
      'Warnings_Raster_Source',
      'Warnings_Raster_Layer',
      warningsLayer,
    );

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
    await mapboxMapController.addImage(
      'stormsurge',
      stormSurge.buffer.asUint8List(),
    );
    await mapboxMapController.setSymbolIconAllowOverlap(true);
    mapboxMapController.onSymbolTapped.add(onSymbolTappedErrorWrapper);

    final List<ADSB> adsbList = await ref.read(adsbStreamProvider.future);
    await loadADSBSymbols(adsbList);
    final List<Ship> shipsList = await ref.read(shipsStreamProvider.future);
    await loadShipssymbols(shipsList);
    final List<ActiveTFR> activeTFRs =
        await ref.read(activeTFRsStreamProvider.future);
    await loadActiveTFRsymbols(activeTFRs);
    final List<Weather> weatherStormSurges =
        await ref.read(weatherStormSurgesStreamProvider.future);
    await loadWeatherStormSurgesSymbols(weatherStormSurges);

    hasStylesLoaded = true;

    if (tappedSymbolId == null) {
      Timer(const Duration(milliseconds: 200), () async {
        if (mounted) {
          await getLastMapCoordinates();
        }
      });
    } else {
      if (Platform.isAndroid) {
        await moveToSymbol(tappedSymbolId);
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
    if (tappedSymbolId != null) {
      tappedSymbolId = null;
    }
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
    for (final ADSB adsb in adsbList) {
      final String image = adsb.type == 'plane' ? 'plane' : 'heli';

      final String? imageUrl =
          adsb.imageUrl != null ? 'https://chaseapp.tv${adsb.imageUrl}' : null;

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
        if (symbol.id == tappedSymbolId) {
          await onSymbolTapped(symbol);
        }
      }
    }
  }

  Future<void> updateADSBSymbols(List<ADSB> adsbList) async {
    log('ADSB Data Update');
    final List<Symbol> presentSymbols = mapboxMapController.symbols.toList();
    for (final ADSB adsb in adsbList) {
      final String image = adsb.type == 'plane' ? 'plane' : 'heli';

      final Symbol? symbol = findSymbol(<String, dynamic>{
        'symbols': presentSymbols,
        'id': adsb.id,
      });
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
      final List<List<LatLng>> geomtery = await compute(createGeoJSONCircle, {
        'coordinates': activeTFR.geometry.coordinates,
        'radiusArc': activeTFR.properties.radiusArc,
      });
      await mapboxMapController.addFill(
        FillOptions(
          geometry: geomtery,
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

  Future<void> loadWeatherStormSurgesSymbols(
    List<Weather> weatherStormSurges,
  ) async {
    log('WeatherStormSurges Data Update');

    for (final Weather weatherStormSurge in weatherStormSurges) {
      for (final WeatherStation station in weatherStormSurge.stations) {
        final Symbol symbol = await mapboxMapController.addSymbol(
          SymbolOptions(
            geometry: LatLng(station.lat, station.lng),
            iconImage: 'stormsurge',
            iconSize: 0.8,
          ),
          <String, dynamic>{
            'id': station.id,
          },
        );
        if (Platform.isAndroid) {
          if (symbol.id == tappedSymbolId) {
            await onSymbolTapped(symbol);
          }
        }
      }
    }
  }

  Future<void> loadShipssymbols(List<Ship> shipsList) async {
    for (final Ship ship in shipsList) {
      final Symbol symbol = await mapboxMapController.addSymbol(
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
      if (Platform.isAndroid) {
        if (symbol.id == tappedSymbolId) {
          await onSymbolTapped(symbol);
        }
      }
    }
  }

  void deleteShipSymbols(List<Ship> deletedShips) {
    final List<Symbol> presentSymbols = mapboxMapController.symbols.toList();

    for (final Ship ship in deletedShips) {
      final Symbol? symbol = findSymbol(<String, dynamic>{
        'symbols': presentSymbols,
        'id': ship.id,
      });
      if (symbol != null) {
        mapboxMapController.removeSymbol(symbol);
      }
    }
  }

  void deleteADSBSymbols(List<ADSB> deletedADSBs) {
    final List<Symbol> presentSymbols = mapboxMapController.symbols.toList();

    for (final ADSB adsb in deletedADSBs) {
      final Symbol? symbol = findSymbol(<String, dynamic>{
        'symbols': presentSymbols,
        'id': adsb.id,
      });
      if (symbol != null) {
        mapboxMapController.removeSymbol(symbol);
      }
    }
  }

  Future<void> updateShipssymbols(List<Ship> shipsList) async {
    log('Ships Data Update');
    final Stopwatch timer = Stopwatch()..start();
    final List<Symbol> presentSymbols = mapboxMapController.symbols.toList();

    for (final Ship ship in shipsList) {
      final Symbol? symbol = findSymbol(<String, dynamic>{
        'symbols': presentSymbols,
        'id': ship.id,
      });
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
    timer.stop();
    log('Took ${timer.elapsed.inSeconds}');
  }

  Future<void> updateWeatherStormSurgesSymbols(
    List<Weather> weatherStormSurges,
  ) async {
    log('WeatherStormSurges Data Update');
    final Stopwatch timer = Stopwatch()..start();
    final List<Symbol> stormSurgeSymbols = mapboxMapController.symbols
        .where(
          (Symbol symbol) => symbol.options.iconImage == 'stormsurge',
        )
        .toList();
    await mapboxMapController.removeSymbols(stormSurgeSymbols);
    await loadWeatherStormSurgesSymbols(weatherStormSurges);

    timer.stop();
    log('Took ${timer.elapsed.inSeconds}');
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
    tappedSymbolId = widget.symbolId;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (state != AppLifecycleState.resumed) {
      if (hasStylesLoaded) {
        if (mounted) {
          await saveCameralastPosition(
            mapboxMapController.cameraPosition?.target,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (hasStylesLoaded) {
      mapboxMapController.onSymbolTapped.remove(onSymbolTappedErrorWrapper);
      saveCameralastPosition(mapboxMapController.cameraPosition?.target);
    }
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
        final List<Ship> prevItems = previous?.value ?? [];
        if (hasStylesLoaded && previous != null) {
          // find ship objects that've changed in next list
          final List<Ship> deletedItems = prevItems.where((Ship prevItem) {
            return shipsList.firstWhereOrNull(
                      (Ship element) => element.id == prevItem.id,
                    ) ==
                    null
                ? true
                : false;
          }).toList();

          deleteShipSymbols(deletedItems);
          await updateShipssymbols(shipsList);
        }
      },
    );

    ref.listen<AsyncValue<List<ADSB>>>(
      adsbStreamProvider,
      (AsyncValue<List<ADSB>>? previous, AsyncValue<List<ADSB>> next) async {
        final List<ADSB> adsbsList = next.value ?? [];
        if (hasStylesLoaded && previous != null) {
          final List<ADSB> deletedItems =
              previous.value!.where((ADSB prevItem) {
            return adsbsList.firstWhereOrNull(
                      (ADSB element) => element.id == prevItem.id,
                    ) ==
                    null
                ? true
                : false;
          }).toList();
          deleteADSBSymbols(deletedItems);
          await updateADSBSymbols(adsbsList);
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
    ref.listen<AsyncValue<List<Weather>>>(
      weatherStormSurgesStreamProvider,
      (
        AsyncValue<List<Weather>>? previous,
        AsyncValue<List<Weather>> next,
      ) async {
        final List<Weather> weatherStormSurgesList = next.value ?? [];
        if (hasStylesLoaded && previous != null) {
          await updateWeatherStormSurgesSymbols(weatherStormSurgesList);
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

    // await mapboxMapController.addSource(
    //   'ADSBSOURCE',
    //   GeojsonSourceProperties(
    //     cluster: true,
    //     data: <String, dynamic>{
    //       'type': 'FeatureCollection',
    //       'features': adsbList.map((ADSB adsb) {
    //         final String image = adsb.type == 'plane' ? 'plane' : 'heli';

    //         final String? imageUrl = adsb.imageUrl != null
    //             ? 'https://chaseapp.tv${adsb.imageUrl}'
    //             : null;

    //         return {
    //           'type': 'Feature',
    //           'id': adsb.id,
    //           'properties': {
    //             // 'title': adsb.id,
    //             'id': adsb.id,
    //             'group': adsb.group,
    //             'subtitle': adsb.group,
    //             'imageUrl': imageUrl,
    //             'type': 'adsb',
    //             'iconRotation': adsb.track,
    //             'iconImage': image,
    //             // 'icon': {
    //             //   'iconImage': image,
    //             //   'iconRotate': adsb.track,
    //             // },
    //           },
    //           'geometry': {
    //             'type': 'Point',
    //             'coordinates': [
    //               adsb.lon,
    //               adsb.lat,
    //             ],
    //           },
    //         };
    //       }).toList(),
    //     },
    //   ),
    // );
    // await mapboxMapController.addSymbolLayer(
    //   'ADSBSOURCE',
    //   'ADSBLAYER',
    //   const SymbolLayerProperties(
    //     iconImage: ['get', 'iconImage'],
    //     iconRotate: ['get', 'iconRotation'],
    //   ),
    // );