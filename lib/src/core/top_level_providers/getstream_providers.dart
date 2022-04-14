import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/chats/view/providers/providers.dart';

final FutureProviderFamily<String, String> fetchUserTokenForGetStream =
    FutureProvider.family<String, String>((
  FutureProviderRef<String> ref,
  String uid,
) async {
  return ref.read(chatsRepoProvider).getUserToken(uid);
});
