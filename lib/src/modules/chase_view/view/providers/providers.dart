import 'package:flutter_riverpod/flutter_riverpod.dart';

// final chaseDetailsHeightProvider = StateProvider<double?>((ref) => null);
final playVideoProvider = StateProvider.autoDispose<bool>((ref) => false);
final isShowingChatsWindowProvide =
    StateProvider.autoDispose<bool>((ref) => false);
