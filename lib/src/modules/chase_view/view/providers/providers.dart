import 'package:flutter_riverpod/flutter_riverpod.dart';

// final chaseDetailsHeightProvider = StateProvider<double?>((ref) => null);
final playVideoProvider = StateProvider.autoDispose<bool>((ref) => false);
final showChatsWindowProvider = StateProvider.autoDispose<bool>((ref) => false);
