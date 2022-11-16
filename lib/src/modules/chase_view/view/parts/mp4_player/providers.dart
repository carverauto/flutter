import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isFullScreenProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});
