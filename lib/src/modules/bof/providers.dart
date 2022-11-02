import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/birds_of_fire/birds_of_fire.dart';
import 'bof_db.dart';

final Provider<BOFDB> bofDBProvider = Provider<BOFDB>((ProviderRef<BOFDB> ref) {
  return BOFDB();
});

final StreamProvider<List<BirdsOfFire>> bofStreamProvider =
    StreamProvider<List<BirdsOfFire>>(
  (
    StreamProviderRef<List<BirdsOfFire>> ref,
  ) {
    return ref.read(bofDBProvider).getBofProperties();
  },
);
