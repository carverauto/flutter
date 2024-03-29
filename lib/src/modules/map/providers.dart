import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/top_level_providers/services_providers.dart';
import '../../models/activeTFR/activeTFR.dart';
import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import '../../models/weather/weather.dart';
import 'data/mapdb.dart';

final Provider<MapDB> mapDBProvider = Provider<MapDB>((ProviderRef<MapDB> ref) {
  return MapDB(
    sharedPreferences: ref.read(sharedPreferancesProvider),
  );
});

final StreamProvider<List<ADSB>> adsbStreamProvider =
    StreamProvider<List<ADSB>>((StreamProviderRef<List<ADSB>> ref) {
  return ref.read(mapDBProvider).adsbStream();
});
final StreamProvider<List<Ship>> shipsStreamProvider =
    StreamProvider<List<Ship>>((StreamProviderRef<List<Ship>> ref) {
  return ref.read(mapDBProvider).shipsStream();
});
final StreamProvider<List<ActiveTFR>> activeTFRsStreamProvider =
    StreamProvider<List<ActiveTFR>>((StreamProviderRef<List<ActiveTFR>> ref) {
  return ref.read(mapDBProvider).activeTFRsStream();
});
final StreamProvider<List<Weather>> weatherStormSurgesStreamProvider =
    StreamProvider<List<Weather>>((StreamProviderRef<List<Weather>> ref) {
  return ref.read(mapDBProvider).weatherStormSurgesStream;
});
