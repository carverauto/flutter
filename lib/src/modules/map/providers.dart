import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/adsb/adsb.dart';
import '../../models/ship/ship.dart';
import 'data/mapdb.dart';

final Provider<MapDB> mapDBProvider = Provider<MapDB>((ProviderRef<MapDB> ref) {
  return MapDB();
});

final StreamProvider<List<ADSB>> adsbStreamProvider =
    StreamProvider<List<ADSB>>((StreamProviderRef<List<ADSB>> ref) {
  return ref.read(mapDBProvider).adsbStream();
});
final StreamProvider<List<Ship>> shipsStreamProvider =
    StreamProvider<List<Ship>>((StreamProviderRef<List<Ship>> ref) {
  return ref.read(mapDBProvider).shipsStream();
});
