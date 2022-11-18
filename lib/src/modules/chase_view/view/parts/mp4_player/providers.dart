import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isFullScreenProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<String?> mp4PlauerPlayEventsStreamProovider =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  return null;
});

final StateProvider<String?> youtubePlauerPlayEventsStreamProovider =
    StateProvider<String?>((StateProviderRef<String?> ref) {
  return null;
});
